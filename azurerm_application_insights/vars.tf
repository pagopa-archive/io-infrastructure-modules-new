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

variable "retention_in_days" {
  type    = number
  default = 180
}

variable "application_type" {
  type    = string
  default = "other"
}

locals {
  resource_name = "${var.global_prefix}-${var.environment_short}-ai-${var.name}"
}
