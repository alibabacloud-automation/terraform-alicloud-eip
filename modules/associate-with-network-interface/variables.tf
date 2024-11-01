
variable "instance_charge_type" {
  description = "(Deprecated from version 1.3.0) Elastic IP instance charge type. Use payment_type instead."
  type        = string
  default     = "PostPaid"
}

variable "number_of_eips" {
  description = "The number of eip to be created. This parameter will be ignored if `number_of_computed_instances` and `instances` is used."
  type        = number
  default     = 0
}

variable "name" {
  description = "Name to be used on all resources as prefix. Default to 'TF-Module-EIP'. The final default name would be TF-Module-EIP001, TF-Module-EIP002 and so on."
  type        = string
  default     = "TF-Module-EIP"
}

variable "description" {
  description = " Description of the EIP, This description can have a string of 2 to 256 characters, It cannot begin with http:// or https://. Default value is null."
  type        = string
  default     = "An EIP associated with NetworkInterface instance."
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

variable "tags" {
  description = "A mapping of tags to assign to the EIP instance resource."
  type        = map(string)
  default     = {}
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

variable "computed_instances" {
  description = "List of NatInterface instances created by calling alicloud_network_interface."
  type = list(object({
    instance_type = string
    instance_ids  = list(string)
    private_ips   = list(string)
  }))
  default = []
}

