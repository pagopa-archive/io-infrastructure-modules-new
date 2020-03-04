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
  type = object({
    name     = string
    tier     = string
    capacity = number
  })
}

variable "public_ip_info" {
  type = object({
    sku               = string
    allocation_method = string
  })
}

variable "virtual_network_info" {
  type = object({
    resource_group_name   = string
    name                  = string
    subnet_address_prefix = string
  })
}

variable "frontend_port" {
  type = number
}

variable "custom_domains" {
  type = object({
    zone_name                 = string
    zone_resource_group_name  = string
    keyvault_id               = string
    keyvault_certificate_name = string
  })
}

variable "services" {
  type = list(object({
    name  = string
    a_record_name = string

    http_listener = object({
      protocol = string
      host_name = string
    })

    backend_address_pool = object({
      ip_addresses = list(string)
    })

    probe = object({
      host                = string
      protocol            = string
      path                = string
      interval            = number
      timeout             = number
      unhealthy_threshold = number
    })

    backend_http_settings = object({
      protocol              = string
      port                  = number
      path                  = string
      cookie_based_affinity = string
      request_timeout       = number
    })
  }))
}

locals {
  resource_name                  = "${var.global_prefix}-${var.environment_short}-ag-${var.name}"
  gateway_ip_configuration_name  = "gatewayipconfiguration"
  frontend_ip_configuration_name = "frontendipconfiguration"
  frontend_port_name             = "frontendport"
}
