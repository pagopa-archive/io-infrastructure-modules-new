# General variables

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

variable "name" {
  type = string
}

variable "ntfns_namespace_type" {
  type        = string
  description = "The Type of Namespace - possible values are Messaging or NotificationHub."
}

variable "ntfns_sku_name" {
  type        = string
  description = "The SKU name of the notification hub namespace. Possible values are Free, Basic or Standard."
}

variable "ntfns_enabled" {
  type        = bool
  description = "Is this Notification Hub Namespace enabled?"
  default     = true
}

variable "resource_group_name" {
  type = string
}

locals {
  resource_name = "${var.global_prefix}-${var.environment_short}-ntfns-${var.name}"
}
