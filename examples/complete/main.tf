data "alicloud_zones" "default" {
}

data "alicloud_images" "default" {
  name_regex = "ubuntu_18"
}

data "alicloud_instance_types" "default" {
  availability_zone = data.alicloud_zones.default.zones.0.id
}

data "alicloud_resource_manager_resource_groups" "default" {
}

resource "alicloud_nat_gateway" "default" {
  count = 3

  vpc_id               = module.vpc.this_vpc_id
  vswitch_id           = module.vpc.this_vswitch_ids[0]
  nat_type             = var.nat_type
  specification        = var.specification
  payment_type         = "PayAsYouGo"
  internet_charge_type = "PayByLcu"
  period               = var.period
}

resource "alicloud_ecs_network_interface" "default" {
  security_group_ids = [module.security_group.this_security_group_id]
  vswitch_id         = module.vpc.this_vswitch_ids[1]
}

resource "alicloud_slb_load_balancer" "default" {
  vswitch_id         = module.vpc.this_vswitch_ids[2]
  address_type       = "intranet"
  load_balancer_spec = var.load_balancer_spec
}

module "vpc" {
  source             = "alibaba/vpc/alicloud"
  create             = true
  vpc_cidr           = "172.16.0.0/12"
  vswitch_cidrs      = [cidrsubnet("172.16.0.0/12", 8, 8), cidrsubnet("172.16.0.0/12", 8, 10), cidrsubnet("172.16.0.0/12", 8, 12), cidrsubnet("172.16.0.0/12", 8, 16)]
  availability_zones = [data.alicloud_zones.default.zones.0.id]
}

module "security_group" {
  source = "alibaba/security-group/alicloud"
  vpc_id = module.vpc.this_vpc_id
}

module "ecs_instance" {
  source = "alibaba/ecs-instance/alicloud"

  number_of_instances = 1

  instance_type      = data.alicloud_instance_types.default.instance_types.0.id
  image_id           = data.alicloud_images.default.images.0.id
  vswitch_ids        = [module.vpc.this_vswitch_ids[3]]
  security_group_ids = [module.security_group.this_security_group_id]
}

module "example" {
  source = "../.."

  #alicloud_eip
  create         = true
  number_of_eips = 1
  use_num_suffix = true

  name                 = var.name
  description          = var.description
  bandwidth            = var.bandwidth
  internet_charge_type = "PayByTraffic"
  payment_type         = "PayAsYouGo"
  period               = var.period
  isp                  = "BGP"
  resource_group_id    = data.alicloud_resource_manager_resource_groups.default.ids.0
  tags                 = var.tags

  #alicloud_eip_association
  number_of_computed_instances = 1

  instances = [
    {
      instance_ids  = [alicloud_nat_gateway.default.0.id]
      instance_type = "Nat"
      private_ips   = ["172.16.0.1"]
    }
  ]

  computed_instances = [
    {
      instance_ids  = [alicloud_nat_gateway.default.1.id]
      instance_type = "Nat"
      private_ips   = ["172.16.0.2"]
    }
  ]

}

//ecs
module "associate-with-ecs" {
  source = "../../modules/associate-with-ecs"

  #alicloud_eip
  create         = true
  number_of_eips = 1

  name                 = var.name
  description          = var.description
  bandwidth            = var.bandwidth
  internet_charge_type = "PayByTraffic"
  payment_type         = "PayAsYouGo"
  period               = var.period
  isp                  = "BGP"
  resource_group_id    = data.alicloud_resource_manager_resource_groups.default.ids.0
  tags                 = var.tags

  #alicloud_eip_association
  number_of_computed_instances = 1

  computed_instances = [
    {
      instance_ids  = module.ecs_instance.this_instance_id
      instance_type = "EcsInstance"
      private_ips   = []
    }
  ]

  #date source alicloud_instances
  name_regex = "foo*"
  instance_tags = {
    Create = "tf"
    Env    = "prod"
  }
  instance_resource_group_id = data.alicloud_resource_manager_resource_groups.default.ids.0

}

//nat-gateway
module "associate-with-nat" {
  source = "../../modules/associate-with-nat-gateway"

  #alicloud_eip
  create         = true
  number_of_eips = 1

  name                 = var.name
  description          = var.description
  bandwidth            = var.bandwidth
  internet_charge_type = "PayByTraffic"
  payment_type         = "PayAsYouGo"
  period               = var.period
  isp                  = "BGP"
  resource_group_id    = data.alicloud_resource_manager_resource_groups.default.ids.0
  tags                 = var.tags

  #alicloud_eip_association
  number_of_computed_instances = 1

  computed_instances = [
    {
      instance_ids  = [alicloud_nat_gateway.default.2.id]
      instance_type = "Nat"
      private_ips   = ["172.16.0.6"]
    }
  ]

  #data source alicloud_nat_gateways
  name_regex = "prod*"

}

//network-interface
module "associate-with-network-interface" {
  source = "../../modules/associate-with-network-interface"

  #alicloud_eip
  create         = true
  number_of_eips = 1

  name                 = var.name
  description          = var.description
  bandwidth            = var.bandwidth
  internet_charge_type = "PayByTraffic"
  payment_type         = "PayAsYouGo"
  period               = var.period
  isp                  = "BGP"
  resource_group_id    = data.alicloud_resource_manager_resource_groups.default.ids.0
  tags                 = var.tags

  #alicloud_eip_association
  number_of_computed_instances = 1

  computed_instances = [
    {
      instance_ids  = [alicloud_ecs_network_interface.default.id]
      instance_type = "NetworkInterface"
      private_ips   = []
    }
  ]

  #data source alicloud_network_interfaces
  name_regex = "foo*"
  instance_tags = {
    Create = "tf"
    Env    = "prod"
  }
  instance_resource_group_id = data.alicloud_resource_manager_resource_groups.default.ids.0

}

//slb
module "associate-with-slb" {
  source = "../../modules/associate-with-slb"

  #alicloud_eip
  create         = true
  number_of_eips = 1

  name                 = var.name
  description          = var.description
  bandwidth            = var.bandwidth
  internet_charge_type = "PayByTraffic"
  payment_type         = "PayAsYouGo"
  period               = var.period
  isp                  = "BGP"
  resource_group_id    = data.alicloud_resource_manager_resource_groups.default.ids.0
  tags                 = var.tags

  #alicloud_eip_association
  number_of_computed_instances = 1

  computed_instances = [
    {
      instance_ids  = [alicloud_slb_load_balancer.default.id]
      instance_type = "SlbInstance"
      private_ips   = ["172.16.0.8"]
    }
  ]

  #data source alicloud_network_interfaces
  name_regex = "bar*"
  instance_tags = {
    Create = "tf"
    Env    = "prod"
  }
  instance_resource_group_id = data.alicloud_resource_manager_resource_groups.default.ids.0

}