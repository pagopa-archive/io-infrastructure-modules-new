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

variable "publisher_name" {
  type = string
}

variable "publisher_email" {
  type = string
}

variable "notification_sender_email" {
  type = string
}

variable "sku_name" {
  type = string
}

variable "virtual_network_info" {
  type = object({
    resource_group_name   = string
    name                  = string
    subnet_address_prefix = string
  })
}

variable "application_insights_instrumentation_key" {
  type = string
}

variable "custom_domains" {
  type = object({
    zone_name                 = string
    zone_resource_group_name  = string
    keyvault_id               = string
    keyvault_certificate_name = string

    domains = list(object({
      name    = string
      default = bool
    }))
  })
}

variable "named_values_map" {
  type = map(any)
}

locals {
  resource_name = "${var.global_prefix}-${var.environment_short}-apim-${var.name}"
}
