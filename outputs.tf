#################
# EIP
#################
output "this_eip_id" {
  description = "The EIP ID."
  value       = alicloud_eip.this.*.id
}

output "this_eip_name" {
  description = "The name of the EIP."
  value       = alicloud_eip.this.*.name
}

output "this_eip_description" {
  description = "Description of the EIP."
  value       = alicloud_eip.this.*.description
}

output "this_eip_internet_charge_type" {
  description = "Internet charge type of the EIP."
  value       = alicloud_eip.this.*.internet_charge_type
}

output "this_eip_instance_charge_type" {
  description = "Elastic IP instance charge type."
  value       = alicloud_eip.this.*.instance_charge_type
}

output "this_eip_bandwidth" {
  description = "The elastic public network bandwidth."
  value       = alicloud_eip.this.*.bandwidth
}

output "this_eip_isp" {
  description = "The line type of the Elastic IP."
  value       = alicloud_eip.this.*.isp
}


output "this_eip_status" {
  description = "The EIP current status."
  value       = alicloud_eip.this.*.status
}

output "this_eip_address" {
  description = "The elastic ip address."
  value       = alicloud_eip.this.*.ip_address
}

output "this_eip_tags" {
  description = "The EIP instance tags."
  value       = alicloud_eip.this.*.tags
}

output "this_eip_resource_group_id" {
  description = "The EIP belongs to this resource_group_id. "
  value       = alicloud_eip.this.*.resource_group_id
}

#################
# EIP Association
#################
output "this_eip_association_id" {
  description = "The allocation EIP ID."
  value       = alicloud_eip_association.this.*.allocation_id
}

output "this_eip_association_instance_id" {
  description = "The ID of the ECS or SLB instance or Nat Gateway."
  value       = alicloud_eip_association.this.*.instance_id
}

output "this_eip_association_instance_type" {
  description = "The type of cloud product that the eip instance to bind."
  value       = alicloud_eip_association.this.*.instance_type
}