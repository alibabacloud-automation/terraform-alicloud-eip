locals {
  instance_list = flatten(
    [
      for _, obj in var.instances : [
        for index, id in obj["instance_ids"] : {
          instance_id        = id
          instance_type      = obj["instance_type"]
          private_ip_address = obj["private_ips"] != null && length(obj["private_ips"]) > index ? obj["private_ips"][index] : null
        }
      ]
    ]
  )
  eip_count = (length(local.instance_list) > 0 ? length(local.instance_list) : var.number_of_eips)
}

resource "alicloud_eip" "this" {
  for_each = var.create ? {
    for i in range(0, local.eip_count) : tostring(i) => {}
  } : {}

  address_name         = local.eip_count > 1 || var.use_num_suffix ? format("%s%03d", var.name, each.key + 1) : var.name
  description          = var.description
  bandwidth            = var.bandwidth
  internet_charge_type = var.internet_charge_type
  payment_type         = var.payment_type != "" ? var.payment_type : var.instance_charge_type == "PostPaid" ? "PayAsYouGo" : "Subscription"
  period               = var.period
  isp                  = var.isp
  resource_group_id    = var.resource_group_id
  tags = merge(
    {
      Name = local.eip_count > 1 || var.use_num_suffix ? format("%s%03d", var.name, each.key + 1) : var.name
    },
    var.tags,
  )
}

resource "alicloud_eip_association" "this" {
  for_each = var.create ? {
    for i, instance in local.instance_list : tostring(i) => instance
  } : {}

  allocation_id      = alicloud_eip.this[each.key].id
  instance_id        = lookup(each.value, "instance_id")
  instance_type      = lookup(each.value, "instance_type")
  private_ip_address = lookup(each.value, "private_ip_address")
}