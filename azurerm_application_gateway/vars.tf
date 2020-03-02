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

// Resource Group 
variable "resource_group_name" {
  type = string
}

// Module Variables
variable "ip_sku" {
  type        = string
  description = "The SKU of the Public IP."
}

variable "ip_allocation_method" {
  type        = string
  description = "Defines the allocation method for this IP address."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "The log_analytics workspace id"
}

variable "virtual_network_name" {
  type        = string
  description = "The virtual network name."
}

variable "subnet_address_prefix" {
  type        = string
  description = "The subnet id for AG"
}

variable "subnet_resource_group_name" {
  type = string
}

variable "key_vault_id" {
  type        = string
  description = "The keyvault id"
}

variable "certificate_name" {
  type        = string
  description = "The name of the ssl certificate."
}

variable "certificate_password" {
  type        = string
  description = "The password of the ssl certificate."
}

# Application Gateway plan specific variables
variable "azurerm_public_ip_allocation_method" {
  type        = string
  description = "The public ip associated to the Application Gateway."
  default     = "Dynamic"
}

variable "sku_name" {
  type        = string
  description = "The application gateway sku name."
  default     = "WAF_v2"
}

variable "sku_tier" {
  type        = string
  description = "The application gateway sku tier"
  default     = "WAF_v2"
}

variable "asc_min_capacity" {
  type        = number
  description = "Minimum capacity for autoscaling."
  default     = 2
}

variable "asc_max_capacity" {
  type        = number
  description = "Maximum capacity for autoscaling."
  default     = 4
}

variable "frontend_port_number" {
  type        = number
  description = "The port used for this Frontend Port."
  default     = 443
}

variable "http2" {
  type        = bool
  description = "Is HTTP2 enabled on the application gateway resource?"
  default     = false
}

variable "wc_enabled" {
  description = "Enable the Web Application Firewall."
  default     = true
}

variable "wc_firewall_mode" {
  description = "The Web Application Firewall Mode"
  default     = "Detection"
}

variable "wc_rule_set_type" {
  type        = string
  description = "The Type of the Rule Set used for this Web Application Firewall."
  default     = "OWASP"
}

variable "wc_rule_set_version" {
  type        = string
  description = "The Version of the Rule Set used for this Web Application Firewall."
  default     = "3.1"
}

variable "diagnostic_logs_retention" {
  type        = number
  description = "The number of days for which this Retention Policy should apply."
  default     = 30
}

variable "diagnostic_metrics_retention" {
  type        = number
  description = "The number of days for which this Retention Policy should apply."
  default     = 30
}

variable "services" {
  type = list(object({
    hl = object({
      name                       = string
      host_name                  = string
      protocol                   = string
      require_sni                = string
      custom_error_configuration = map(string)
    })
    pb = object({
      name                = string
      interval            = number
      protocol            = string
      path                = string
      timeout             = number
      unhealthy_threshold = number
      host                = string
    })
    bhs = object({
      name                  = string
      cookie_based_affinity = string
      path                  = string
      port                  = number
      probe_name            = string
      protocol              = string
      request_timeout       = number
      host_name             = string
    })
    rrr = object({
      name      = string
      rule_type = string
    })
    bap = object({
      name         = string
      ip_addresses = list(string)
    })
  }))
}

locals {
  resource_name                  = "${var.global_prefix}-${var.environment_short}-ag-${var.name}"
  ag_ip_resource_name            = "${var.global_prefix}-${var.environment_short}-ag-ip-${var.name}"

  request_routing_rule =  [
    for entry in var.services: {
      name                       = entry.rrr.name
      rule_type                  = entry.rrr.rule_type
      http_listener_name         = entry.hl.name
      backend_address_pool_name  = entry.bap.name
      backend_http_settings_name = entry.bhs.name 
    }
  ]

  gateway_ip_configuration_name  = "${var.global_prefix}-${var.environment_short}-ag-ip-${var.name}"
  frontend_port_name             = "${var.global_prefix}-${var.environment_short}-ag-feport-${var.name}"
  frontend_ip_configuration_name = "${var.global_prefix}-${var.environment_short}-ag-feip-${var.name}"
  redirect_configuration_name    = "${var.global_prefix}-${var.environment_short}-ag-rdrcfg-${var.name}"
  ssl_certificate_name           = "${var.global_prefix}-${var.environment_short}-ag-ssl-${var.name}"
  diagnostic_name                = "${var.global_prefix}-${var.environment_short}-ag-diagnostic-${var.name}"
}
