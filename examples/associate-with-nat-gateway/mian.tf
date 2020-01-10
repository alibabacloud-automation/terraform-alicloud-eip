variable "region" {
  default = "cn-beijing"
}

provider "alicloud" {
  region = var.region
}

#################################
# Data sources to get VPC details
#################################

data "alicloud_vpcs" "default" {
  is_default = true
}

#########################################################################
# alicloud_nat_gateway which is used as an argument in associate-with-nat-gateway-gateway
#########################################################################

resource "alicloud_nat_gateway" "default" {
  name   = "test-eip-gateway"
  vpc_id = data.alicloud_vpcs.default.ids.0
}

########################################################################
# eip full parameters associated with associate-with-nat-gateway-gateway
########################################################################


module "associate-with-nat" {
  source = "../../modules/associate-with-nat-gateway"
  region = var.region

  create               = true
  name                 = "eip-nat-example"
  bandwidth            = 5
  internet_charge_type = "PayByTraffic"
  instance_charge_type = "PostPaid"
  period               = 1

  # The number of instances created by calling the API. If this parameter is used, `number_of_eips` will be ignored.
  number_of_computed_instances = 1
  computed_instances = [
    {
      instance_ids  = [alicloud_nat_gateway.default.id]
      instance_type = "Nat"
      private_ips   = []
    }
  ]

  # ECS instances found by this conditions. If these parameter is used, `number_of_eips` will be ignored.
  name_regex = "product*"
}