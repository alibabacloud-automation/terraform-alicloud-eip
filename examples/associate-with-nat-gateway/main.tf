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

############################################
# Resource to create VPC, vswitch
############################################

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

#########################################################################
# alicloud_nat_gateway which is used as an argument in associate-with-nat-gateway-gateway
#########################################################################

resource "alicloud_nat_gateway" "default" {
  vpc_id           = alicloud_vpc.default.id
  nat_gateway_name = local.name
  payment_type     = "PayAsYouGo"
  vswitch_id       = alicloud_vswitch.default.id
  nat_type         = "Enhanced"
}

########################################################################
# eip full parameters associated with associate-with-nat-gateway-gateway
########################################################################


module "associate-with-nat" {
  source = "../../modules/associate-with-nat-gateway"
  region = var.region

  create               = true
  name                 = local.name
  bandwidth            = 5
  internet_charge_type = "PayByTraffic"
  instance_charge_type = "PostPaid"
  period               = 1

  # The number of Nat Gateway created by its resoruce. If this parameter is used, `number_of_eips` will be ignored.
  number_of_computed_instances = 1
  computed_instances = [
    {
      instance_ids  = [alicloud_nat_gateway.default.id]
      instance_type = "Nat"
      private_ips   = []
    }
  ]

  # Nat Gateway can be found automactically by name_regex, instance_tags and instance_resource_group_id. If these parameter is used, `number_of_eips` will be ignored.
  name_regex = "prod*"
}