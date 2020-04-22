# General Variables
variable "global_prefix" {
  type = string
}

variable "environment" {
  type = string
}

variable "environment_short" {
  type = string
}

variable "region" {
  type = string
}

variable "namespace_name" {
  type = string
}

// Resource Group 
variable "resource_group_name" {
  type = string
}

variable "auto_inflate_enabled" {
  type        = bool
  description = "Is Auto Inflate enabled for the EventHub Namespace?"
  default     = false
}

variable "eventhubs" {
  type = list(object({
    name              = string
    partition_count   = number
    message_retention = number
  }))
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
  description = "The list of eventhub authorization rules. Each rule is expressed as a dictionary. Each dictionary can contain the keys name, eventhub_name ,listen, send, manage"
  type        = list
  default     = []
}

locals {
  # Eventhub namespace.
  evhns_resource_name = "${var.global_prefix}-${var.environment_short}-evhns-${var.namespace_name}"
}
