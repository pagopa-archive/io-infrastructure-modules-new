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

locals {
  resource_name = "${var.global_prefix}-${var.environment_short}-lapp-${var.name}"
}
