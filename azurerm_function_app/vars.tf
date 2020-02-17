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

variable "resource_group_name" {
  type = string
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

variable virtual_network_info {
  type = object({
    resource_group_name   = string
    name                  = string
    subnet_address_prefix = string
  })
}

variable application_insights_instrumentation_key {
  type = string
}

locals {
  resource_name = "${var.global_prefix}-${var.environment}-func-${var.name}"
}

// TODO: Remove
variable "key_vault_id" {
  type = string
}

variable "secrets_map" {
  type = map(string)

  default = {}
}