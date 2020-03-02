variable "global_tenant_id" {
  type = string
}

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

variable "sku" {
  type    = string
  default = "Standard_Microsoft"
}

locals {
  resource_name = "${var.global_prefix}-${var.environment_short}-cdn-${var.name}"
}
