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

variable "runtime_version" {
  type    = string
  default = "~2"
}

variable "function_app_id" {
  type        = string
  default     = null
  description = "This is required when it's set the subnet id for vNet integration."
}

variable "function_app_name" {
  type = string
}

variable "function_app_resource_name" {
  type = string
}

variable "app_service_plan_id" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "storage_account_access_key" {
  type = string
}

variable "pre_warmed_instance_count" {
  type = number

  default = 1
}

variable "auto_swap_slot_name" {
  type        = string
  description = "The name of the slot to automatically swap to during deployment"
  default     = null
}

variable application_insights_instrumentation_key {
  type = string
}

variable app_settings {
  type = map(any)

  default = {}
}

variable app_settings_secrets {
  type = object({
    key_vault_id = string
    map          = map(string)
  })
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

variable "cors" {
  type = object({
    allowed_origins = list(string)
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

variable export_default_key {
  type    = bool
  default = false
}

variable "health_check_path" {
  type    = string
  default = null
}

variable "health_check_maxpingfailures" {
  type     = number
  default = 10
}
