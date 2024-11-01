provider "alicloud" {
  region = var.region
}
resource "random_uuid" "default" {
}
locals {
  name = substr("tf-example-${replace(random_uuid.default.result, "-", "")}", 0, 16)
}

data "alicloud_images" "ubuntu" {
  most_recent = true
  name_regex  = "^ubuntu_18.*64"
}

############################################
# Resource to create VPC, vswitch
############################################

data "alicloud_zones" "default" {
  available_resource_creation = "Instance"
}

resource "alicloud_vpc" "default" {
  vpc_name   = local.name
  cidr_block = "10.4.0.0/16"
}

resource "alicloud_vswitch" "default" {
  vswitch_name = local.name
  cidr_block   = "10.4.0.0/24"
  vpc_id       = alicloud_vpc.default.id
  zone_id      = data.alicloud_zones.default.zones[0].id
}

data "alicloud_instance_types" "default" {
  cpu_core_count    = 1
  memory_size       = 2
  availability_zone = data.alicloud_zones.default.zones[0].id
}

####################################################################
# web_server_sg which is used as an argument in ecs_cluster
####################################################################

module "web_server_sg" {
  source  = "alibaba/security-group/alicloud//modules/http-80"
  version = "~>2.4.0"

  region = var.region

  name                = local.name
  description         = "Security group for web-server with HTTP ports open within VPC"
  vpc_id              = alicloud_vpc.default.id
  ingress_cidr_blocks = ["10.10.0.0/16"]
}

################################################################
# ecs_cluster which is used as an argument in associate-with-ecs
################################################################

module "ecs_cluster" {
  source  = "alibaba/ecs-instance/alicloud"
  version = "~> 2.0"
  region  = var.region

  number_of_instances         = 2
  name                        = local.name
  use_num_suffix              = true
  image_id                    = data.alicloud_images.ubuntu.ids[0]
  instance_type               = data.alicloud_instance_types.default.ids[0]
  vswitch_id                  = alicloud_vswitch.default.id
  security_group_ids          = [module.web_server_sg.this_security_group_id]
  associate_public_ip_address = false
  system_disk_category        = "cloud_ssd"
  system_disk_size            = 50
  tags = {
    Created     = "Terraform"
    Environment = "dev"
  }
}

########################################################
# eip full parameters associated with associate-with-ecs
########################################################

module "associate-with-ecs" {
  source = "../../modules/associate-with-ecs"

  name                 = local.name
  bandwidth            = 5
  internet_charge_type = "PayByTraffic"
  instance_charge_type = "PostPaid"
  period               = 1
  tags = {
    Env      = "Private"
    Location = "foo"
  }

  # The number of ECS instances created by other modules. If this parameter is used, `number_of_eips` will be ignored.
  computed_instances = [
    {
      instance_ids  = module.ecs_cluster.this_instance_id
      instance_type = "EcsInstance"
      private_ips   = []
    }
  ]

  # ECS instances can be found automactically by name_regex, instance_tags and instance_resource_group_id. If these parameter is used, `number_of_eips` will be ignored.
  name_regex = "foo*"
  instance_tags = {
    Create = "tf"
    Env    = "prod"
  }
  instance_resource_group_id = "rs-132452"
}
