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
  type    = string
  default = null
}

variable "resource_group_name" {
  type        = string
  description = "DEPRECATED: resource group name without prefix and environment. Use just name whenever it is possible."
  default     = null
}

locals {
  resource_name = var.resource_group_name != null ? var.resource_group_name : "${var.global_prefix}-${var.environment_short}-rg-${var.name}"
}
