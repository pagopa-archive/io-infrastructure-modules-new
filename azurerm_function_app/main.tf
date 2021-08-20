terraform {
  required_version = ">= 0.14.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.46.1"
    }
  }
  backend "azurerm" {}
}

data "azurerm_key_vault_secret" "allowed_ips_secret" {
  count = var.allowed_ips_secret == null ? 0 : 1

  name         = var.allowed_ips_secret.key_vault_secret
  key_vault_id = var.allowed_ips_secret.key_vault_id
}

module "storage_account" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_storage_account?ref=optional-storage-account-advanced_threat_protection"

  global_prefix     = var.global_prefix
  environment       = var.environment
  environment_short = var.environment_short
  region            = var.region

  name                              = "${var.resources_prefix.storage_account}${var.name}"
  resource_group_name               = var.resource_group_name
  account_tier                      = var.storage_account_info.account_tier
  account_replication_type          = var.storage_account_info.account_replication_type
  access_tier                       = var.storage_account_info.access_tier
  advanced_threat_protection_enable = true
}

module "storage_account_durable_function" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_storage_account?ref=optional-storage-account-advanced_threat_protection"

  global_prefix     = var.global_prefix
  environment       = var.environment
  environment_short = var.environment_short
  region            = var.region

  name                              = "${var.resources_prefix.storage_account}d${var.name}"
  resource_group_name               = var.resource_group_name
  account_tier                      = var.storage_account_info.account_tier
  account_replication_type          = var.storage_account_info.account_replication_type
  access_tier                       = var.storage_account_info.access_tier
  advanced_threat_protection_enable = false

  network_rules = {
    default_action = "Deny"
    ip_rules       = []
    bypass = [
      "Logging",
      "Metrics",
      "AzureServices",
    ]
    virtual_network_subnet_ids = [
      local.subnet_id
    ]
  }
}

module "storage_account_durable_function_private_endpoint_blob" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_private_endpoint?ref=v3.0.10"

  global_prefix     = var.global_prefix
  environment       = var.environment
  environment_short = var.environment_short
  region            = var.region

  name                = "${module.storage_account_durable_function.resource_name}-blob-endpoint"
  resource_group_name = var.resource_group_name
  subnet_id           = var.storage_durable_function_private_endpoint.subnet_id

  private_service_connection = {
    name                           = "${module.storage_account_durable_function.resource_name}-blob"
    private_connection_resource_id = module.storage_account_durable_function.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_ids = var.storage_durable_function_private_endpoint.private_dns_zone_blob_ids
}

module "storage_account_durable_function_private_endpoint_queue" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_private_endpoint?ref=v3.0.10"

  global_prefix     = var.global_prefix
  environment       = var.environment
  environment_short = var.environment_short
  region            = var.region

  name                = "${module.storage_account_durable_function.resource_name}-queue-endpoint"
  resource_group_name = var.resource_group_name
  subnet_id           = var.storage_durable_function_private_endpoint.subnet_id

  private_service_connection = {
    name                           = "${module.storage_account_durable_function.resource_name}-queue"
    private_connection_resource_id = module.storage_account_durable_function.id
    is_manual_connection           = false
    subresource_names              = ["queue"]
  }

  private_dns_zone_ids = var.storage_durable_function_private_endpoint.private_dns_zone_queue_ids
}

module "storage_account_durable_function_private_endpoint_table" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_private_endpoint?ref=v3.0.10"

  global_prefix     = var.global_prefix
  environment       = var.environment
  environment_short = var.environment_short
  region            = var.region

  name                = "${module.storage_account_durable_function.resource_name}-table-endpoint"
  resource_group_name = var.resource_group_name
  subnet_id           = var.storage_durable_function_private_endpoint.subnet_id

  private_service_connection = {
    name                           = "${module.storage_account_durable_function.resource_name}-table"
    private_connection_resource_id = module.storage_account_durable_function.id
    is_manual_connection           = false
    subresource_names              = ["table"]
  }

  private_dns_zone_ids = var.storage_durable_function_private_endpoint.private_dns_zone_table_ids
}

module "app_service_plan" {
  count  = var.app_service_plan_id == null ? 1 : 0
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_app_service_plan?ref=v3.0.3"

  global_prefix     = var.global_prefix
  environment       = var.environment
  environment_short = var.environment_short
  region            = var.region

  name                = "${var.resources_prefix.app_service_plan}${var.name}"
  resource_group_name = var.resource_group_name
  kind                = var.app_service_plan_info.kind
  sku_tier            = var.app_service_plan_info.sku_tier
  sku_size            = var.app_service_plan_info.sku_size
}

module "secrets_from_keyvault" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_secrets_from_keyvault?ref=v3.0.3"

  key_vault_id = var.app_settings_secrets.key_vault_id
  secrets_map  = var.app_settings_secrets.map
}

locals {
  allowed_ips        = [for ip in var.allowed_ips : { ip_address = ip, virtual_network_subnet_id = null }]
  allowed_subnets    = [for s in var.allowed_subnets : { ip_address = null, virtual_network_subnet_id = s }]
  allowed_ips_secret = [for ip in var.allowed_ips_secret == null ? [] : split(";", data.azurerm_key_vault_secret.allowed_ips_secret[0].value) : { ip_address = ip, virtual_network_subnet_id = null }]
  ip_restrictions    = concat(local.allowed_subnets, local.allowed_ips_secret, local.allowed_ips)
  subnet_id          = var.subnet_id != null ? var.subnet_id : module.subnet[0].id
}

resource "azurerm_function_app" "function_app" {
  name                       = local.resource_name
  resource_group_name        = var.resource_group_name
  location                   = var.region
  version                    = var.runtime_version
  app_service_plan_id        = var.app_service_plan_id != null ? var.app_service_plan_id : module.app_service_plan[0].id
  storage_account_name       = module.storage_account.resource_name
  storage_account_access_key = module.storage_account.primary_access_key

  site_config {
    min_tls_version           = "1.2"
    ftps_state                = "Disabled"
    pre_warmed_instance_count = var.pre_warmed_instance_count

    dynamic "ip_restriction" {
      for_each = local.ip_restrictions
      iterator = ip

      content {
        ip_address                = ip.value.ip_address
        virtual_network_subnet_id = ip.value.virtual_network_subnet_id
      }
    }

    dynamic "cors" {
      for_each = var.cors != null ? [var.cors] : []
      content {
        allowed_origins = cors.value.allowed_origins
      }
    }

    health_check_path = var.health_check_path != null ? var.health_check_path : null

  }

  app_settings = merge(
    {
      APPINSIGHTS_INSTRUMENTATIONKEY = var.application_insights_instrumentation_key
      # No downtime on slots swap
      WEBSITE_ADD_SITENAME_BINDINGS_IN_APPHOST_CONFIG = 1
      # default value for health_check_path, override it in var.app_settings if needed
      WEBSITE_HEALTHCHECK_MAXPINGFAILURES = var.health_check_path != null ? var.health_check_maxpingfailures : null
      # https://docs.microsoft.com/en-us/samples/azure-samples/azure-functions-private-endpoints/connect-to-private-endpoints-with-azure-functions/
      DURABLE_FUNCTION_STORAGE_CONNECTION_STRING = module.storage_account_durable_function.primary_connection_string
      SLOT_TASK_HUBNAME                          = "ProductionTaskHub"
      WEBSITE_RUN_FROM_PACKAGE                   = 1
      WEBSITE_VNET_ROUTE_ALL                     = 1
      WEBSITE_DNS_SERVER                         = "168.63.129.16"
      # this app settings is required to solve the issue:
      # https://github.com/terraform-providers/terraform-provider-azurerm/issues/10499
      WEBSITE_CONTENTSHARE = "${local.resource_name}-content"
    },
    var.app_settings,
    module.secrets_from_keyvault.secrets_with_value
  )

  enable_builtin_logging = false

  tags = {
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_CONTENTSHARE"],
    ]
  }
}

# this datasource has been introduced within version 2.27.0
data "azurerm_function_app_host_keys" "app_host_keys" {
  count               = var.export_keys ? 1 : 0
  name                = local.resource_name
  resource_group_name = var.resource_group_name
  depends_on          = [azurerm_function_app.function_app]
}

module "subnet" {
  count  = var.avoid_old_subnet_delete == false && (var.subnet_id != null || var.virtual_network_info == null) ? 0 : 1
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_subnet?ref=v3.0.3"

  global_prefix     = var.global_prefix
  environment       = var.environment
  environment_short = var.environment_short
  region            = var.region

  name                 = "f${var.name}"
  resource_group_name  = var.virtual_network_info != null ? var.virtual_network_info.resource_group_name : "none"
  virtual_network_name = var.virtual_network_info != null ? var.virtual_network_info.name : "none"
  address_prefix       = var.virtual_network_info != null ? var.virtual_network_info.subnet_address_prefix : "none"

  delegation = {
    name = "default"

    service_delegation = {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

  service_endpoints = [
    "Microsoft.Web"
  ]
}

resource "azurerm_app_service_virtual_network_swift_connection" "app_service_virtual_network_swift_connection" {
  count = var.subnet_id == null && var.virtual_network_info == null ? 0 : 1

  app_service_id = azurerm_function_app.function_app.id
  subnet_id      = local.subnet_id
}
