module "eip-slb" {
  source = "../../"

  number_of_eips       = var.number_of_eips
  name                 = var.name
  description          = var.description
  bandwidth            = var.bandwidth
  internet_charge_type = var.internet_charge_type
  payment_type         = var.payment_type != "" ? var.payment_type : var.instance_charge_type == "PostPaid" ? "PayAsYouGo" : "Subscription"
  period               = var.period
  isp                  = var.isp
  resource_group_id    = var.resource_group_id
  tags = merge(
    {
      UsedFor = local.instance_type
    },
    var.tags,
  )

  # number_of_computed_instances = var.number_of_computed_instances
  instances = local.instances
  # computed_instances           = var.computed_instances
}

locals {
  instance_type = "SlbInstance"
  instances = var.name_regex != "" || length(var.instance_tags) > 0 || var.instance_resource_group_id != "" ? concat([
    {
      instance_ids  = data.alicloud_slbs.this.ids
      instance_type = local.instance_type
      private_ips   = []
    }
  ], var.computed_instances) : null
}

data "alicloud_slbs" "this" {
  name_regex        = var.name_regex
  tags              = var.instance_tags
  resource_group_id = var.instance_resource_group_id
}