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
    account_tier                      = string
    account_replication_type          = string
    access_tier                       = string
    advanced_threat_protection_enable = bool
  })

  default = {
    account_tier                      = "Standard"
    account_replication_type          = "LRS"
    access_tier                       = "Hot"
    advanced_threat_protection_enable = false
  }
}

variable "app_service_plan_id" {
  type        = string
  description = "The app service plan id to associate to the function. If null a new plan is created, if not null the app_service_plan_info is not relevant."
  default     = null
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

variable "application_insights_instrumentation_key" {
  type = string
}

variable "app_settings" {
  type = map(any)

  default = {}
}

variable "app_settings_secrets" {
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

variable "virtual_network_info" {
  type = object({
    name                  = string
    resource_group_name   = string
    subnet_address_prefix = string
  })

  default = null
}

variable "durable_function" {
  type = object({
    enable                     = bool
    private_endpoint_subnet_id = string
    private_dns_zone_blob_ids  = list(string)
    private_dns_zone_queue_ids = list(string)
    private_dns_zone_table_ids = list(string)
    queues                     = list(string)
    containers                 = list(string)
    blobs_retention_days       = number
  })

  default = {
    enable                     = false
    private_endpoint_subnet_id = "dummy"
    private_dns_zone_blob_ids  = []
    private_dns_zone_queue_ids = []
    private_dns_zone_table_ids = []
    queues                     = []
    containers                 = []
    blobs_retention_days       = 1
  }
}

variable "avoid_old_subnet_delete" {
  type = bool

  default = false
}

variable "export_keys" {
  type    = bool
  default = false
}

variable "health_check_path" {
  type    = string
  default = null
}

variable "health_check_maxpingfailures" {
  type    = number
  default = 10
}

variable "web_test" {
  type = object({
    application_insights_id = string
    enabled                 = bool
  })
  default = null
}

variable "advanced_threat_protection_enable" {
  type        = bool
  default     = false
  description = "Enable advanced threat protection on the storage accounts"
}

locals {
  resource_name = "${var.global_prefix}-${var.environment_short}-${var.resources_prefix.function_app}-${var.name}"
}
