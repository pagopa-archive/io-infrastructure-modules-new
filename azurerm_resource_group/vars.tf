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

locals {
  resource_name = var.resource_group_name != null ? var.resource_group_name : "${var.global_prefix}-${var.environment_short}-rg-${var.name}"
}
