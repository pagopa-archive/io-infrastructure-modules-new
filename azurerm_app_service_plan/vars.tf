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

variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

# App service plan specific variables

variable "kind" {
  type = string
}

variable "sku_tier" {
  type = string
}

variable "sku_size" {
  type = string
}

variable "sku_capacity" {
  type    = number
  default = null
}

variable "maximum_elastic_worker_count" {
  type    = number
  default = null
}

variable "reserved" {
  type    = bool
  default = false
}

variable "per_site_scaling" {
  type    = bool
  default = null
}

locals {
  resource_name = "${var.global_prefix}-${var.environment_short}-plan-${var.name}"
}
