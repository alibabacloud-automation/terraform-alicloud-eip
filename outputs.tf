#################
# EIP
#################
output "this_eip_id" {
  description = "The EIP ID."
  value       = concat(alicloud_eip.this.*.id, [""])[0]
}

output "this_eip_name" {
  description = "The name of the EIP."
  value       = concat(alicloud_eip.this.*.name, [""])[0]
}

output "this_eip_description" {
  description = "Description of the EIP."
  value       = concat(alicloud_eip.this.*.description, [""])[0]
}

output "this_eip_internet_charge_type" {
  description = "Internet charge type of the EIP."
  value       = concat(alicloud_eip.this.*.internet_charge_type, [""])[0]
}

output "this_eip_instance_charge_type" {
  description = "Elastic IP instance charge type."
  value       = concat(alicloud_eip.this.*.instance_charge_type, [""])[0]
}

output "this_eip_bandwidth" {
  description = "The elastic public network bandwidth."
  value       = concat(alicloud_eip.this.*.bandwidth, [""])[0]
}

output "this_eip_isp" {
  description = "The line type of the Elastic IP."
  value       = concat(alicloud_eip.this.*.isp, [""])[0]
}

output "this_eip_status" {
  description = "The EIP current status."
  value       = concat(alicloud_eip.this.*.status, [""])[0]
}

output "this_eip_address" {
  description = "The elastic ip address."
  value       = concat(alicloud_eip.this.*.ip_address, [""])[0]
}

output "this_eip_tags" {
  description = "The EIP instance tags."
  value       = concat(alicloud_eip.this.*.tags, [""])[0]
}

output "this_eip_resource_group_id" {
  description = "The EIP belongs to this resource_group_id. "
  value       = concat(alicloud_eip.this.*.resource_group_id, [""])[0]
}

#################
# EIP Association
#################
output "this_eip_association_id" {
  description = "The allocation EIP ID."
  value       = concat(alicloud_eip_association.this.*.allocation_id, [""])[0]
}

output "this_eip_association_instance_id" {
  description = "The ID of the ECS or SLB instance or Nat Gateway."
  value       = concat(alicloud_eip_association.this.*.instance_id, [""])[0]
}

output "this_eip_association_instance_type" {
  description = "The type of cloud product that the eip instance to bind."
  value       = concat(alicloud_eip_association.this.*.instance_type, [""])[0]
}