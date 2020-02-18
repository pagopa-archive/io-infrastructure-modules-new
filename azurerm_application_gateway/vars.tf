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
  description = ""
}

variable "virtual_network_name" {
  type        = string
  description = "The virtual network name."
}

variable "subnet_address_prefix" {
  type        = string
  description = "The subnet id for AG"
}

variable "key_vault_id" {
  type        = string
  description = "The keyvault id"
}

variable "frontend" {
  type        = list(number)
  description = "The frontend ports used by AG"
  default     = []
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

variable "autoscaling_configuration_min_capacity" {
  type        = number
  description = "Minimum capacity for autoscaling."
  default     = 2
}

variable "autoscaling_configuration_max_capacity" {
  type        = number
  description = "Maximum capacity for autoscaling."
  default     = 2
}

variable "frontend_port_port" {
  type        = number
  description = "The port used for this Frontend Port."
  default     = 443
}

variable "http2" {
  type        = bool
  description = "Is HTTP2 enabled on the application gateway resource?"
  default     = false
}

variable "waf_configuration_enabled" {
  description = "Enable the Web Application Firewall."
  default     = true
}

variable "waf_configuration_firewall_mode" {
  description = "he Web Application Firewall Mode"
  default     = "Detection"
}

variable "waf_configuration_rule_set_type" {
  type        = string
  description = "The Type of the Rule Set used for this Web Application Firewall."
  default     = "OWASP"
}

variable "waf_configuration_rule_set_version" {
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

variable "ag" {
  type = list(object({
      hl_name                           = string
      hl_host_name                      = string
      hl_protocol                       = string
      hl_require_sni                    = string
      hl_ssl_certificate_name           = string
      hl_custom_error_configuration     = map(string)

      probe_name                                      = string
      probe_interval                                  = number
      probe_protocol                                  = string
      probe_path                                      = string
      probe_timeout                                   = number
      probe_unhealthy_threshold                       = number
      probe_host                                      = string
      # probe_match                                     = map(string)
      # probe_minimum_servers                           = number
      # probe_pick_host_name_from_backend_http_settings = bool

      bhs_name                                = string
      bhs_cookie_based_affinity               = string
      # bhs_affinity_cookie_name                = string
      bhs_path                                = string
      bhs_port                                = number
      bhs_probe_name                          = string
      bhs_protocol                            = string
      bhs_request_timeout                     = number
      bhs_host_name                           = string
      # bhs_pick_host_name_from_backend_address = bool
      # bhs_authentication_certificate          = map(string)
      # bhs_trusted_root_certificate_names      = list(string)
      # bhs_connection_draining                 = map(string)  

      rrr_name                        = string
      rrr_rule_type                   = string
      rrr_http_listener_name          = string
      rrr_backend_address_pool_name   = string
      rrr_backend_http_settings_name  = string
      # rrr_redirect_configuration_name = string
      # rrr_rewrite_rule_set_name       = string
      # rrr_url_path_map_name           = string

      bap_name         = string
      # bap_fqdns        = list(string)
      bap_ip_addresses = list(string)

  }))
  # default = null
}

locals {
  resource_name        = "${var.global_prefix}-${var.environment}-ag-${var.name}"
  ip_resource_name     = "${var.global_prefix}-${var.environment}-ip-${var.name}"
  ag_ip_resource_name  = "${var.global_prefix}-${var.environment}-ag-ip-${var.name}"
  subnet_resource_name = "${var.global_prefix}-${var.environment}-subnet-${var.name}"

  gateway_ip_configuration_name  = "${var.global_prefix}-${var.environment}-ag-ip-${var.name}"
  frontend_port_name             = "${var.global_prefix}-${var.environment}-ag-feport-${var.name}"
  frontend_ip_configuration_name = "${var.global_prefix}-${var.environment}-ag-feip-${var.name}"
  redirect_configuration_name    = "${var.global_prefix}-${var.environment}-ag-rdrcfg-${var.name}"
  ssl_certificate_name           = "${var.global_prefix}-${var.environment}-ag-ssl-${var.name}"
  diagnostic_name                = "${var.global_prefix}-${var.environment}-ag-diagnostic-${var.name}"
  #host_name                      = "${var.application_gateway_hostname}${var.environment == "prod" ? "." : ".${var.environment}."}io.italia.it"
  # azurerm_key_vault_secret_certificate                       = "application-gateway-${var.application_gateway_name_suffix}-cert"
}
