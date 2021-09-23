#################
# Provider
#################
variable "region" {
  description = "(Deprecated from version 1.2.0) The region used to launch this module resources."
  default     = "cn-shanghai"
}

variable "profile" {
  description = "(Deprecated from version 1.2.0) The profile name as set in the shared credentials file. If not set, it will be sourced from the ALICLOUD_PROFILE environment variable."
  default     = ""
}
variable "shared_credentials_file" {
  description = "(Deprecated from version 1.2.0) This is the path to the shared credentials file. If this is not set and a profile is specified, $HOME/.aliyun/config.json will be used."
  default     = ""
}

variable "skip_region_validation" {
  description = "(Deprecated from version 1.2.0) Skip static validation of region ID. Used by users of alternative AlibabaCloud-like APIs or users w/ access to regions that are not public (yet)."
  default     = false
}

#################
# EIP
#################
variable "create" {
  description = "Whether to create an EIP instance and whether to associate EIP with other resources."
  default     = true
}

variable "number_of_eips" {
  description = "The number of eip to be created. This parameter will be ignored if `number_of_computed_instances` and `instances` is used."
  type        = number
  default     = 0
}

variable "name" {
  description = "Name to be used on all resources as prefix. Default to 'TF-Module-EIP'. The final default name would be TF-Module-EIP001, TF-Module-EIP002 and so on."
  default     = "TF-Module-EIP"
}

variable "bandwidth" {
  description = "Maximum bandwidth to the elastic public network, measured in Mbps (Mega bit per second)."
  type        = number
  default     = 5
}

variable "internet_charge_type" {
  description = "Internet charge type of the EIP, Valid values are `PayByBandwidth`, `PayByTraffic`. "
  type        = string
  default     = "PayByTraffic"
}

variable "instance_charge_type" {
  description = "Elastic IP instance charge type."
  type        = string
  default     = "PostPaid"
}

variable "period" {
  description = "The duration that you will buy the resource, in month."
  type        = number
  default     = 1
}

variable "tags" {
  description = "A mapping of tags to assign to the EIP instance resource."
  type        = map(string)
  default     = {}
}

variable "status" {
  description = "The EIP current status."
  type        = string
  default     = ""
}

variable "isp" {
  description = "The line type of the Elastic IP instance."
  type        = string
  default     = ""
}

variable "resource_group_id" {
  description = "The Id of resource group which the eip belongs."
  type        = string
  default     = ""
}

variable "ip_address" {
  description = "The elastic ip address."
  type        = string
  default     = ""
}

variable "instance_tags" {
  description = "Query NetworkInterface instances based on tags."
  type        = map(string)
  default     = {}
}

variable "instance_resource_group_id" {
  description = "Query NetworkInterface instance based on resource_group_id."
  type        = string
  default     = ""
}

variable "name_regex" {
  description = "Query NetworkInterface instance based on name_regex."
  type        = string
  default     = ""
}

#################
# EIP Association
#################
variable "instances" {
  description = "A list of instances found by the condition. If this parameter is used, `number_of_eips` will be ignored."
  type = list(object({
    instance_type = string
    instance_ids  = list(string)
    private_ips   = list(string)
  }))
  default = []
}

variable "computed_instances" {
  description = "List of NatInterface instances created by calling alicloud_network_interface."
  type = list(object({
    instance_type = string
    instance_ids  = list(string)
    private_ips   = list(string)
  }))
  default = []
}

variable "number_of_computed_instances" {
  description = "The number of instances created by calling the API. If this parameter is used, `number_of_eips` will be ignored."
  type        = number
  default     = 0
}
