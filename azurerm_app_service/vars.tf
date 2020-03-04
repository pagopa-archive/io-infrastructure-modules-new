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

variable "log_analytics_workspace_id" {
  type        = string
  description = "The log_analytics workspace id"
}

variable "app_service_plan_info" {
  type = object({
    kind     = string
    sku_tier = string
    sku_size = string
  })

  default = {
    kind     = "elastic"
    sku_tier = "ElasticPremium"
    sku_size = "EP1"
  }
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

variable "app_settings" {
  type    = map(any)
  default = {}
}

variable "app_settings_secrets" {
  type = object({
    key_vault_id = string
    map          = map(string)
  })
}

variable "client_cert_enabled" {
  type    = bool
  default = false
}

variable "ip_restriction" {
  type    = list(any)
  default = null
}

variable "https_only" {
  type    = bool
  default = true
}

variable "app_enabled" {
  type        = bool
  description = "Is the App Service Enabled?"
  default     = true
}

variable "custom_hostname" {
  type = string
}

variable "ssl_state" {
  type    = string
  default = "SniEnabled"
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

variable "dns_cname_record" {
  type = object({
    zone_name                = string
    zone_resource_group_name = string
  })

  default = null
}

locals {
  resource_name           = "${var.global_prefix}-${var.environment_short}-app-${var.name}"
  diagnostic_name         = "${var.global_prefix}-${var.environment_short}-app-diagnostic-${var.name}"
  app_service_certificate = "${var.global_prefix}-${var.environment_short}-app-certificate-${var.name}"
}
