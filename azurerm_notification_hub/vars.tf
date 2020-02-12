# General variables

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

variable "resource_group_name" {
  type = string
}

# Notification Hub related variables
variable "key_vault_id" {
  type        = string
  description = "The azure key vault id."
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

variable "ntf_apns_credential_application_mode" {
  type        = string
  description = "The Application Mode which defines which server the APNS Messages should be sent to. Possible values are Production and Sandbox."
}

locals {
  resource_name       = "${var.global_prefix}-${var.environment}-ntf-${var.name}"
  ntfns_resource_name = "${var.global_prefix}-${var.environment}-ntfns-${var.name}"
}
