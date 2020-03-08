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

variable "key_vault_id" {
  type = string
}

variable "certificate_name" {
  type = string
}

locals {
  app_service_certificate = "${var.global_prefix}-${var.environment_short}-appcertificate-${var.name}"
}
