output "eip_name" {
  description = "The name of the EIP instance."
  value       = module.slb.this_eip_name
}

output "this_eip_bandwidth" {
  description = "The elastic public network bandwidth."
  value       = module.slb.this_eip_bandwidth
}

output "this_eip_isp" {
  description = "The line type of the Elastic IP instance."
  value       = module.slb.this_eip_isp
}

output "this_eip_status" {
  description = "The EIP current status."
  value       = module.slb.this_eip_status
}

output "this_eip_address" {
  description = "The elastic ip address."
  value       = module.slb.this_eip_address
}

output "this_eip_tags" {
  description = "A mapping of tags to assign to the resource"
  value       = module.slb.this_eip_tags
}

output "this_eip_association_id" {
  description = "The allocation EIP ID."
  value       = module.slb.this_eip_association_id
}

output "this_eip_association_instance_id" {
  description = "The SLB instance ID associated with the EIP."
  value       = module.slb.this_eip_association_instance_id
}

output "this_eip_association_instance_type" {
  description = "The type of cloud product that the eip instance to bind."
  value       = module.slb.this_eip_association_instance_type
}