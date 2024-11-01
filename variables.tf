#################
# EIP
#################

variable "number_of_eips" {
  description = "The number of eip to be created."
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

variable "netmode" {
  description = "The network type. By default, this value is set to `public`, which specifies the public network type."
  type        = string
  default     = null
}

variable "allocation_id" {
  description = "The ID of the EIP instance."
  type        = string
  default     = null
}

variable "high_definition_monitor_log_status" {
  description = "The status of fine-grained monitoring."
  type        = string
  default     = null
}

variable "ip_address" {
  description = "The IP address of the EIP. Supports a maximum of 50 EIPs."
  type        = string
  default     = null
}

variable "log_project" {
  description = "The name of the Simple Log Service (SLS) project."
  type        = string
  default     = null
}

variable "log_store" {
  description = "The name of the Logstore."
  type        = string
  default     = null
}

variable "public_ip_address_pool_id" {
  description = "The ID of the IP address pool."
  type        = string
  default     = null
}

variable "security_protection_types" {
  description = "Security protection level."
  type        = list(string)
  default     = []
}

variable "zone" {
  description = "The zone of the EIP."
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the EIP instance resource."
  type        = map(string)
  default     = {}
}


variable "instance_charge_type" {
  description = "(Deprecated from version 1.3.0) Elastic IP instance charge type. Use payment_type instead."
  type        = string
  default     = "PostPaid"
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
