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
  computed_instance_list = flatten(
    [
      for _, obj in var.computed_instances : [
        for index, id in obj["instance_ids"] : {
          instance_id        = id
          instance_type      = obj["instance_type"]
          private_ip_address = obj["private_ips"] != null && length(obj["private_ips"]) > index ? obj["private_ips"][index] : null
        }
      ]
    ]
  )
  eip_count = length(local.instance_list) > 0 ? length(local.instance_list) : var.number_of_eips
}

resource "alicloud_eip" "this" {
  count = var.create ? local.eip_count : 0

  name                 = local.eip_count > 1 || var.use_num_suffix ? format("%s%03d", var.name, count.index + 1) : var.name
  description          = var.description
  bandwidth            = var.bandwidth
  internet_charge_type = var.internet_charge_type
  instance_charge_type = var.instance_charge_type
  period               = var.period
  isp                  = var.isp
  resource_group_id    = var.resource_group_id
  tags = merge(
    {
      Name = local.eip_count > 1 || var.use_num_suffix ? format("%s%03d", var.name, count.index + 1) : var.name
    },
    var.tags,
  )
}

resource "alicloud_eip_association" "this" {
  count = var.create ? length(local.instance_list) : 0

  allocation_id      = alicloud_eip.this[count.index].id
  instance_id        = lookup(local.instance_list[count.index], "instance_id")
  instance_type      = lookup(local.instance_list[count.index], "instance_type")
  private_ip_address = lookup(local.instance_list[count.index], "private_ip_address")
}

resource "alicloud_eip" "with_computed" {
  count = var.create ? var.number_of_computed_instances : 0

  name                 = var.number_of_computed_instances > 1 || var.use_num_suffix ? format("%s%03d", var.name, count.index + 1) : var.name
  description          = var.description
  bandwidth            = var.bandwidth
  internet_charge_type = var.internet_charge_type
  instance_charge_type = var.instance_charge_type
  period               = var.period
  isp                  = var.isp
  resource_group_id    = var.resource_group_id
  tags = merge(
    {
      Name = length(local.computed_instance_list) > 1 || var.use_num_suffix ? format("%s%03d", var.name, count.index + 1) : var.name
    },
    var.tags,
  )
}
resource "alicloud_eip_association" "with_computed" {
  count = var.create ? var.number_of_computed_instances : 0

  allocation_id      = alicloud_eip.with_computed[count.index].id
  instance_id        = lookup(local.computed_instance_list[count.index], "instance_id")
  instance_type      = lookup(local.computed_instance_list[count.index], "instance_type")
  private_ip_address = lookup(local.computed_instance_list[count.index], "private_ip_address")
}
