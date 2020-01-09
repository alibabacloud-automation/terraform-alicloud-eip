data "alicloud_zones" "default" {
  available_resource_creation = "VSwitch"
}

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

resource "alicloud_security_group" "default" {
  count  = "2"
  vpc_id = alicloud_vpc.default.id
  name   = "test-network_interface-eip"
}

resource "alicloud_network_interface" "default" {
  security_groups = [alicloud_security_group.default[0].id]
  vswitch_id      = alicloud_vswitch.default.id
}

module "network_interface-eip" {
  source = "../../modules/network_interface"

  number_of_eips               = 3
  number_of_computed_instances = 1
  name                         = "NetworkInterface-eip-example"
  bandwidth                    = 5
  internet_charge_type         = "PayByTraffic"
  instance_charge_type         = "PostPaid"
  period                       = 1
  computed_instances = [
    {
      instance_ids  = [alicloud_network_interface.default.id]
      instance_type = "NetworkInterface"
      private_ips   = []
    }
  ]
  name_regex                 = ""
  tags                       = {}
  instance_resource_group_id = ""
}