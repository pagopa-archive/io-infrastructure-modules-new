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

variable "custom_domain" {
  type = object({
    name                     = string
    zone_name                = string
    zone_resource_group_name = string
    key_vault_id             = string
    certificate_name         = string
  })
}

variable "ssl_state" {
  type    = string
  default = "SniEnabled"
}

variable "app_service_name" {
  type = string
}

variable "default_site_hostname" {
  type = string
}


locals {
  app_service_certificate = "${var.global_prefix}-${var.environment_short}-appcertificate-${var.name}"
}
