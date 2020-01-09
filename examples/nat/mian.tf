data "alicloud_vpcs" "default" {
  is_default = true
}

resource "alicloud_nat_gateway" "default" {
  name   = "test-eip-gateway"
  vpc_id = data.alicloud_vpcs.default.ids.0
}

module "nat" {
  source = "../../modules/nat"

  number_of_eips               = 3
  number_of_computed_instances = 1
  name                         = "ecs-gateway-example"
  bandwidth                    = 5
  internet_charge_type         = "PayByTraffic"
  instance_charge_type         = "PostPaid"
  period                       = 1
  computed_instances = [
    {
      instance_ids  = [alicloud_nat_gateway.default.id]
      instance_type = "Nat"
      private_ips   = []
    }
  ]
  name_regex = ""
}