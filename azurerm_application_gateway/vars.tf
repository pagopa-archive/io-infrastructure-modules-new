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

variable "backend_address_pool_ip_addresses" {
  type        = list(string)
  description = "The private ip address associated to the APIM"
  default     = []
}

variable "probe_interval" {
  type        = number
  description = "The Interval between two consecutive probes in seconds."
  default     = 30
}

variable "probe_protocol" {
  type        = string
  description = "The Protocol used for this Probe."
  default     = "Http"
}

variable "probe_timeout" {
  type        = number
  description = "The Timeout used for this Probe, which indicates when a probe becomes unhealthy."
  default     = 120
}

variable "probe_unhealthy_threshold" {
  type        = number
  description = "The Unhealthy Threshold for this Probe, which indicates the amount of retries which should be attempted before a node is deemed unhealthy."
  default     = 8
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "The Log Analytics workspace name."
  default     = "log-analytics-workspace"
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

locals {
  resource_name = "${var.global_prefix}-${var.environment}-ag-${var.name}"



  gateway_ip_configuration_name  = "${var.resource_name_prefix}-${var.environment}-ag-ip-${var.application_gateway_name_suffix}"
  frontend_port_name             = "${var.resource_name_prefix}-${var.environment}-ag-feport-${var.application_gateway_name_suffix}"
  probe_name                     = "${var.resource_name_prefix}-${var.environment}-ag-probe-${var.application_gateway_name_suffix}"
  backend_address_pool_name      = "${var.resource_name_prefix}-${var.environment}-ag-beap-${var.application_gateway_name_suffix}"
  frontend_ip_configuration_name = "${var.resource_name_prefix}-${var.environment}-ag-feip-${var.application_gateway_name_suffix}"
  backend_http_setting_name      = "${var.resource_name_prefix}-${var.environment}-ag-be-htst-${var.application_gateway_name_suffix}"
  http_listener_name             = "${var.resource_name_prefix}-${var.environment}-ag-httplstn-${var.application_gateway_name_suffix}"
  https_listener_name            = "${var.resource_name_prefix}-${var.environment}-ag-httpslstn-${var.application_gateway_name_suffix}"
  request_routing_rule_name      = "${var.resource_name_prefix}-${var.environment}-ag-rqrt-${var.application_gateway_name_suffix}"
  redirect_configuration_name    = "${var.resource_name_prefix}-${var.environment}-ag-rdrcfg-${var.application_gateway_name_suffix}"
  ssl_certificate_name           = "${var.resource_name_prefix}-${var.environment}-ag-ssl-${var.application_gateway_name_suffix}"
  diagnostic_name                = "${var.resource_name_prefix}-${var.environment}-ag-diagnostic-${var.application_gateway_name_suffix}"
  host_name                      = "${var.application_gateway_hostname}${var.environment == "prod" ? "." : ".${var.environment}."}io.italia.it"
  azurerm_key_vault_secret_certificate                       = "application-gateway-${var.application_gateway_name_suffix}-cert"
}
