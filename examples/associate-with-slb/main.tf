variable "region" {
  default = "cn-beijing"
}

provider "alicloud" {
  region = var.region
}

resource "random_uuid" "default" {
}

locals {
  name = substr("tf-example-${replace(random_uuid.default.result, "-", "")}", 0, 16)
}

##############################################################################
# Resource to create VPC, vswitch which is used as an argument in alicloud_slb
##############################################################################

data "alicloud_zones" "default" {
  available_resource_creation = "VSwitch"
}

resource "alicloud_vpc" "default" {
  vpc_name   = local.name
  cidr_block = "10.4.0.0/16"
}

resource "alicloud_vswitch" "default" {
  vswitch_name = local.name
  cidr_block   = "10.4.0.0/24"
  vpc_id       = alicloud_vpc.default.id
  zone_id      = data.alicloud_zones.default.zones.0.id
}

resource "alicloud_slb_load_balancer" "default" {
  load_balancer_name   = local.name
  address_type         = "intranet"
  load_balancer_spec   = "slb.s2.small"
  vswitch_id           = alicloud_vswitch.default.id
  instance_charge_type = "PayBySpec"
}

########################################################
# eip full parameters associated with associate-with-slb
########################################################

module "associate-with-slb" {
  source = "../../modules/associate-with-slb"
  region = var.region

  create               = true
  name                 = local.name
  bandwidth            = 5
  internet_charge_type = "PayByTraffic"
  instance_charge_type = "PostPaid"
  period               = 1
  tags = {
    Env      = "Private"
    Location = "foo"
  }

  # The number of SLB instances created by its resource. If this parameter is used, `number_of_eips` will be ignored.
  number_of_computed_instances = 1
  computed_instances = [
    {
      instance_ids  = [alicloud_slb_load_balancer.default.id]
      instance_type = "SlbInstance"
      private_ips   = []
    }
  ]

  # SLB instances can be found automactically by name_regex, instance_tags and instance_resource_group_id. If these parameter is used, `number_of_eips` will be ignored.
  name_regex = "bar*"
  instance_tags = {
    Create = "tf"
    Env    = "prod"
  }
  instance_resource_group_id = "rs-132452"
}