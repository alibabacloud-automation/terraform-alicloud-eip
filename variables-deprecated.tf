#################
# Provider
#################
variable "region" {
  description = "(Deprecated from version 1.2.0) The region used to launch this module resources."
  type        = string
  default     = ""
}

variable "profile" {
  description = "(Deprecated from version 1.2.0) The profile name as set in the shared credentials file. If not set, it will be sourced from the ALICLOUD_PROFILE environment variable."
  type        = string
  default     = ""
}
variable "shared_credentials_file" {
  description = "(Deprecated from version 1.2.0) This is the path to the shared credentials file. If this is not set and a profile is specified, $HOME/.aliyun/config.json will be used."
  type        = string
  default     = ""
}

variable "skip_region_validation" {
  description = "(Deprecated from version 1.2.0) Skip static validation of region ID. Used by users of alternative AlibabaCloud-like APIs or users w/ access to regions that are not public (yet)."
  type        = bool
  default     = false
}

variable "instance_charge_type" {
  description = "(Deprecated from version 1.3.0) Elastic IP instance charge type. Use payment_type instead."
  type        = string
  default     = "PostPaid"
}

#################
# EIP
#################

variable "create" {
  description = "(Deprecated from version 2.0.0) Whether to create an EIP instance and whether to associate EIP with other resources."
  type        = bool
  default     = true
}

#################
# EIP Association
#################
variable "number_of_computed_instances" {
  description = "(Deprecated from version 2.0.0) The number of instances created by calling the API. If this parameter is used, `number_of_eips` will be ignored."
  type        = number
  default     = 0
}

variable "computed_instances" {
  description = "(Deprecated from version 2.0.0)List of ECS, NAT, SLB or NetworkInterface instances created by calling Corresponding ​​resource."
  type = list(object({
    instance_type = string
    instance_ids  = list(string)
    private_ips   = list(string)
  }))
  default = []
}