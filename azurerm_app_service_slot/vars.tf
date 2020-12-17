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

variable "app_service_id" {
  type = string
}

variable "app_service_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "app_service_plan_id" {
  type = string
}

variable "app_enabled" {
  type        = bool
  description = "Is the App Service Enabled?"
  default     = true
}

variable "https_only" {
  type    = bool
  default = true
}

variable "auto_swap_slot_name" {
  type    = string
  default = null
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
  type    = string
  default = null
}

# Ex. for linux "node /home/site/wwwroot/src/server.js"
variable "app_command_line" {
  type    = string
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
