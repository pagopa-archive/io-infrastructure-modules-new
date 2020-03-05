# General Variables
variable "global_prefix" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "name" {
  type = string
}

// Resource Group 
variable "resource_group_name" {
  type = string
}

variable "partition_count" {
  type        = number
  description = "Specifies the current number of shards on the Event Hub."
}

variable "message_retention" {
  type        = number
  description = "Specifies the number of days to retain the events for this Event Hub. Needs to be between 1 and 7 days."
}

variable "sku" {
  type        = string
  description = "Defines which tier to use. Valid options are Basic and Standard."
}

variable "capacity" {
  type        = number
  description = "Specifies the Capacity / Throughput Units for a Standard SKU namespace."
  default     = null
}

variable "auto_inflate_enabled" {
  type        = bool
  description = "Is Auto Inflate enabled for the EventHub Namespace?"
  default     = false
}

variable "maximum_throughput_units" {
  type        = number
  description = "Specifies the maximum number of throughput units when Auto Inflate is Enabled"
  default     = null
}

variable "network_rulesets" {
  type = list(object({
    default_action = string
    virtual_network_rule = list(object({
      subnet_id                                       = string
      ignore_missing_virtual_network_service_endpoint = bool
    }))
    ip_rule = list(object({
      ip_mask = string
      action  = string
    }))
  }))
  default = []
}

variable "eventhub_authorization_rules" {
  description = "The list of eventhub authorization rules. Each rule is expressed as a dictionary. Each dictionary can contain the keys name, listen, send, manage"
  type        = list
  default     = []
}

locals {
  resource_name       = "${var.global_prefix}-${var.environment}-evh-${var.name}"
  evhns_resource_name = "${var.global_prefix}-${var.environment}-evhns-${var.name}"
}
