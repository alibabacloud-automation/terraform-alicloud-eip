data "alicloud_zones" "default" {
}

data "alicloud_images" "default" {
  name_regex = "ubuntu_18"
}

data "alicloud_instance_types" "default" {
  availability_zone    = data.alicloud_zones.default.zones[0].id
  cpu_core_count       = 2
  memory_size          = 8
  instance_type_family = "ecs.g6"
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
  security_group_ids   = [module.security_group.this_security_group_id]
  vswitch_id           = module.vpc.this_vswitch_ids[1]
  private_ip_addresses = [cidrhost(module.vpc.this_vswitch_cidr_blocks[1], 100)]
}

resource "alicloud_slb_load_balancer" "default" {
  vswitch_id         = module.vpc.this_vswitch_ids[2]
  address_type       = "intranet"
  load_balancer_spec = var.load_balancer_spec
}

module "vpc" {
  source  = "alibaba/vpc/alicloud"
  version = "~>1.11.0"

  create             = true
  vpc_cidr           = "172.16.0.0/12"
  vswitch_cidrs      = [cidrsubnet("172.16.0.0/12", 8, 8), cidrsubnet("172.16.0.0/12", 8, 10), cidrsubnet("172.16.0.0/12", 8, 12), cidrsubnet("172.16.0.0/12", 8, 16)]
  availability_zones = [data.alicloud_zones.default.zones[0].id]
}

module "security_group" {
  source  = "alibaba/security-group/alicloud"
  version = "~>2.4.0"

  vpc_id = module.vpc.this_vpc_id
}

module "ecs_instance" {
  source  = "alibaba/ecs-instance/alicloud"
  version = "~>2.12.0"

  number_of_instances = 1

  instance_type      = data.alicloud_instance_types.default.instance_types[0].id
  image_id           = data.alicloud_images.default.images[0].id
  vswitch_ids        = [module.vpc.this_vswitch_ids[3]]
  security_group_ids = [module.security_group.this_security_group_id]
}

module "example" {
  source = "../.."

  #alicloud_eip
  number_of_eips = 1
  use_num_suffix = true

  name                 = var.name
  description          = var.description
  bandwidth            = var.bandwidth
  internet_charge_type = "PayByTraffic"
  payment_type         = "PayAsYouGo"
  period               = var.period
  isp                  = "BGP"
  resource_group_id    = data.alicloud_resource_manager_resource_groups.default.ids[0]
  tags                 = var.tags

  #alicloud_eip_association
  instances = [
    {
      instance_ids  = module.ecs_instance.this_instance_id
      instance_type = "EcsInstance"
      private_ips   = []
    },
    {
      instance_ids  = alicloud_nat_gateway.default[*].id
      instance_type = "Nat"
      private_ips   = []
    },
    {
      instance_ids  = [alicloud_ecs_network_interface.default.id]
      instance_type = "NetworkInterface"
      private_ips   = [tolist(alicloud_ecs_network_interface.default.private_ip_addresses)[0]]
    },
    {
      instance_ids  = [alicloud_slb_load_balancer.default.id]
      instance_type = "SlbInstance"
      private_ips   = []
    }
  ]
}

#ecs
module "associate-with-ecs" {
  source = "../../modules/associate-with-ecs"

  #alicloud_eip
  number_of_eips = 1

  name                 = var.name
  description          = var.description
  bandwidth            = var.bandwidth
  internet_charge_type = "PayByTraffic"
  payment_type         = "PayAsYouGo"
  period               = var.period
  isp                  = "BGP"
  resource_group_id    = data.alicloud_resource_manager_resource_groups.default.ids[0]
  tags                 = var.tags

  #alicloud_eip_association
  #date source alicloud_instances
  name_regex = "foo*"
  instance_tags = {
    Create = "tf"
    Env    = "prod"
  }
  instance_resource_group_id = data.alicloud_resource_manager_resource_groups.default.ids[0]

}

#nat-gateway
module "associate-with-nat" {
  source = "../../modules/associate-with-nat-gateway"

  #alicloud_eip
  number_of_eips = 1

  name                 = var.name
  description          = var.description
  bandwidth            = var.bandwidth
  internet_charge_type = "PayByTraffic"
  payment_type         = "PayAsYouGo"
  period               = var.period
  isp                  = "BGP"
  resource_group_id    = data.alicloud_resource_manager_resource_groups.default.ids[0]
  tags                 = var.tags

  #alicloud_eip_association
  #data source alicloud_nat_gateways
  name_regex = "prod*"

}

#network-interface
module "associate-with-network-interface" {
  source = "../../modules/associate-with-network-interface"

  #alicloud_eip
  number_of_eips = 1

  name                 = var.name
  description          = var.description
  bandwidth            = var.bandwidth
  internet_charge_type = "PayByTraffic"
  payment_type         = "PayAsYouGo"
  period               = var.period
  isp                  = "BGP"
  resource_group_id    = data.alicloud_resource_manager_resource_groups.default.ids[0]
  tags                 = var.tags

  #alicloud_eip_association
  #data source alicloud_network_interfaces
  name_regex = "foo*"
  instance_tags = {
    Create = "tf"
    Env    = "prod"
  }
  instance_resource_group_id = data.alicloud_resource_manager_resource_groups.default.ids[0]

}

#slb
module "associate-with-slb" {
  source = "../../modules/associate-with-slb"

  #alicloud_eip
  number_of_eips = 1

  name                 = var.name
  description          = var.description
  bandwidth            = var.bandwidth
  internet_charge_type = "PayByTraffic"
  payment_type         = "PayAsYouGo"
  period               = var.period
  isp                  = "BGP"
  resource_group_id    = data.alicloud_resource_manager_resource_groups.default.ids[0]
  tags                 = var.tags

  #alicloud_eip_association
  #data source alicloud_network_interfaces
  name_regex = "bar*"
  instance_tags = {
    Create = "tf"
    Env    = "prod"
  }
  instance_resource_group_id = data.alicloud_resource_manager_resource_groups.default.ids[0]

}
