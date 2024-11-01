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
  count = local.eip_count

  address_name                       = local.eip_count > 1 || var.use_num_suffix ? format("%s%03d", var.name, count.index + 1) : var.name
  description                        = var.description
  bandwidth                          = var.bandwidth
  internet_charge_type               = var.internet_charge_type
  payment_type                       = var.payment_type != "" ? var.payment_type : var.instance_charge_type == "PostPaid" ? "PayAsYouGo" : "Subscription"
  period                             = var.period
  isp                                = var.isp
  resource_group_id                  = var.resource_group_id
  netmode                            = var.netmode
  allocation_id                      = var.allocation_id
  high_definition_monitor_log_status = var.high_definition_monitor_log_status
  ip_address                         = var.ip_address
  log_project                        = var.log_project
  log_store                          = var.log_store
  public_ip_address_pool_id          = var.public_ip_address_pool_id
  security_protection_types          = var.security_protection_types
  zone                               = var.zone
  tags = merge(
    {
      Name = local.eip_count > 1 || var.use_num_suffix ? format("%s%03d", var.name, count.index + 1) : var.name
    },
    var.tags,
  )
}

resource "alicloud_eip_association" "this" {
  count = length(local.instance_list)

  allocation_id      = alicloud_eip.this[count.index].id
  instance_id        = lookup(local.instance_list[count.index], "instance_id", null)
  instance_type      = lookup(local.instance_list[count.index], "instance_type", null)
  private_ip_address = lookup(local.instance_list[count.index], "private_ip_address", null)
}
