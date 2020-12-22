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

variable "address_space" {
  type = list(string)
}

variable "ddos_protection_plan" {
  type = object({
    id     = string
    enable = bool
  })

  default = null
}

variable "lock" {
  type = object({
    name       = string
    lock_level = string
    notes      = string
  })
  default = null
}

locals {
  resource_name = "${var.global_prefix}-${var.environment_short}-vnet-${var.name}"
}
