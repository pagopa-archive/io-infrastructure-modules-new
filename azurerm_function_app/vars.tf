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

variable "resources_prefix" {
  type = object({
    function_app     = string
    app_service_plan = string
    storage_account  = string
  })

  default = {
    function_app     = "func"
    app_service_plan = "f"
    storage_account  = "f"
  }
}

variable "resource_group_name" {
  type = string
}

variable "runtime_version" {
  type    = string
  default = "~2"
}

variable "storage_account_info" {
  type = object({
    account_tier             = string
    account_replication_type = string
    access_tier              = string
  })

  default = {
    account_tier             = "Standard"
    account_replication_type = "LRS"
    access_tier              = "Hot"
  }
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

variable "pre_warmed_instance_count" {
  type = number

  default = 1
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

variable "avoid_old_subnet_delete" {
  type = bool

  default = false
}

variable export_default_key {
  type    = bool
  default = false
}

locals {
  resource_name = "${var.global_prefix}-${var.environment_short}-${var.resources_prefix.function_app}-${var.name}"
}
