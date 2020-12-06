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

variable "app_service_plan_info" {
  type = object({
    kind     = string
    sku_tier = string
    sku_size = string
    reserved = bool
  })

  default = {
    kind     = "elastic"
    sku_tier = "ElasticPremium"
    sku_size = "EP1"
    reserved = null
  }
}

variable "app_enabled" {
  type        = bool
  description = "Is the App Service Enabled?"
  default     = true
}

variable "client_cert_enabled" {
  type    = bool
  default = false
}

variable "https_only" {
  type    = bool
  default = true
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

variable "always_on" {
  type    = bool
  default = true
}

# Ex. for linux "NODE|10-lts"
variable "linux_fx_version" {
  type = string
  default = null
}

# Ex. for linux "node /home/site/wwwroot/src/server.js"
variable "app_command_line" {
  type = string
  default = null
}

variable "allowed_ips" {
  // List of ip
  type    = list(string)
  default = []
}

variable "allowed_ips_secret" {
  // List of ip from a keyvault secret
  type = object({
    key_vault_id     = string
    key_vault_secret = string
  })

  default = null
}

variable "allowed_subnets" {
  // List of subnet id
  type    = list(string)
  default = []
}

variable "subnet_id" {
  type = string

  default = null
}

variable "virtual_network_info" {
  type = object({
    name                  = string
    resource_group_name   = string
    subnet_address_prefix = string
  })

  default = null
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "The log_analytics workspace id"
  default     = null
}

variable "application_logs" {
  type = object({
    key_vault_id             = string
    key_vault_secret_sas_url = string
    level                    = string
    retention_in_days        = number
  })

  default = null
}

locals {
  resource_name = "${var.global_prefix}-${var.environment_short}-app-${var.name}"
}
