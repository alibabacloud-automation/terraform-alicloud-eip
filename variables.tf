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
  description = "Whether to create an EIP instance and whether to associate EIP with other resources."
  type        = bool
  default     = true
}

variable "number_of_eips" {
  description = "The number of eip to be created. This parameter will be ignored if `number_of_computed_instances` and `instances` is used."
  type        = number
  default     = 1
}

variable "use_num_suffix" {
  description = "Always append numerical suffix to instance name, even if number_of_instances is 1"
  type        = bool
  default     = false
}

variable "name" {
  description = "Name to be used on all resources as prefix. Default to 'TF-Module-EIP'. The final default name would be TF-Module-EIP001, TF-Module-EIP002 and so on."
  type        = string
  default     = ""
}

variable "description" {
  description = " Description of the EIP, This description can have a string of 2 to 256 characters, It cannot begin with http:// or https://. Default value is null."
  type        = string
  default     = ""
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

variable "payment_type" {
  description = "The billing method of the NAT gateway."
  type        = string
  default     = "PayAsYouGo"
}

variable "period" {
  description = "The duration that you will buy the resource, in month."
  type        = number
  default     = 1
}

variable "isp" {
  description = "The line type of the Elastic IP instance."
  type        = string
  default     = "BGP"
}

variable "resource_group_id" {
  description = "The Id of resource group which the eip belongs."
  type        = string
  default     = ""
}

variable "tags" {
  description = "A mapping of tags to assign to the EIP instance resource."
  type        = map(string)
  default     = {}
}

#################
# EIP Association
#################
variable "number_of_computed_instances" {
  description = "The number of instances created by calling the API. If this parameter is used, `number_of_eips` will be ignored."
  type        = number
  default     = 0
}

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
  description = "List of ECS, NAT, SLB or NetworkInterface instances created by calling Corresponding ​​resource."
  type = list(object({
    instance_type = string
    instance_ids  = list(string)
    private_ips   = list(string)
  }))
  default = []
}