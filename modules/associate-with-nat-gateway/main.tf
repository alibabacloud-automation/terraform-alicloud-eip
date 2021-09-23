module "eip-nat" {
  source               = "../../"
  create               = var.create
  number_of_eips       = var.number_of_eips
  name                 = var.name
  description          = "An EIP associated with NAT instance."
  bandwidth            = var.bandwidth
  internet_charge_type = var.internet_charge_type
  instance_charge_type = var.instance_charge_type
  period               = var.period
  isp                  = var.isp
  resource_group_id    = var.resource_group_id
  tags = merge(
    {
      UsedFor = local.instance_type
    },
    var.tags,
  )

  number_of_computed_instances = var.number_of_computed_instances
  instances                    = local.instances
  computed_instances           = var.computed_instances
}

locals {
  instance_type = "Nat"
  instances = var.name_regex != "" ? [
    {
      instance_ids  = data.alicloud_nat_gateways.this.ids
      instance_type = local.instance_type
      private_ips   = []
    }
  ] : []
}

data "alicloud_nat_gateways" "this" {
  name_regex = var.name_regex
}