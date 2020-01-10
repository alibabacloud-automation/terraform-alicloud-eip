variable "region" {
  default = "cn-beijing"
}

provider "alicloud" {
  region = var.region
}

data "alicloud_zones" "default" {
  available_resource_creation = "VSwitch"
}

##############################################################################
# Resource to create VPC, vswitch which is used as an argument in alicloud_slb
##############################################################################

resource "alicloud_vpc" "default" {
  name       = "vpc-eip-example"
  cidr_block = "172.16.0.0/12"
}

resource "alicloud_vswitch" "default" {
  vpc_id            = alicloud_vpc.default.id
  cidr_block        = "172.16.0.0/21"
  availability_zone = data.alicloud_zones.default.zones.0.id
  name              = "vswitch-eip-example"
}

resource "alicloud_slb" "default" {
  name          = "eip-example"
  vswitch_id    = alicloud_vswitch.default.id
  address_type  = "intranet"
  specification = "slb.s1.small"
}

########################################################
# eip full parameters associated with associate-with-slb
########################################################

module "associate-with-slb" {
  source = "../../modules/associate-with-slb"
  region = var.region

  create               = true
  name                 = "eip-slb-example"
  bandwidth            = 5
  internet_charge_type = "PayByTraffic"
  instance_charge_type = "PostPaid"
  period               = 1
  tags = {
    Env      = "Private"
    Location = "foo"
  }

  # The number of instances created by calling the API. If this parameter is used, `number_of_eips` will be ignored.
  number_of_computed_instances = 1
  computed_instances = [
    {
      instance_ids  = [alicloud_slb.default.id]
      instance_type = "SlbInstance"
      private_ips   = []
    }
  ]

  # ECS instances found by these conditions. If these parameter is used, `number_of_eips` will be ignored.
  name_regex = "product*"
  instance_tags = {
    Create = "tf"
    Env    = "prod"
  }
  instance_resource_group_id = "rs-132452"
}