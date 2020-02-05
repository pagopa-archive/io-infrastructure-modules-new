# General Variables

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

# App service plan specific variables

variable "app_service_plan_parameters" {
  type = any
}

locals {
  resource_name = "${var.global_prefix}-${var.environment}-plan-${var.name}"
}
