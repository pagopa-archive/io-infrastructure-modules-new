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

variable "resource_group_name" {
  type = string
}

variable "parameters" {
  description = "(Optional) A map of Key-Value pairs"
  type        = map(string)
  default     = {}
}

variable "parameters_secrets" {
  type = object({
    key_vault_id = string
    map          = map(string)
  })
}

locals {
  resource_name = "${var.global_prefix}-${var.environment_short}-lapp-${var.name}"
}
