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

variable "sku" {
  type = string
}

variable "allocation_method" {
  type = string
}

locals {
  resource_name = "${var.global_prefix}-${var.environment}-pip-${var.name}"
}
