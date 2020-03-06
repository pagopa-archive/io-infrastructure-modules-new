provider "azurerm" {
  version = "=1.44.0"
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

module "app_service_plan" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_app_service_plan?ref=v0.0.24"

  global_prefix     = var.global_prefix
  environment       = var.environment
  environment_short = var.environment_short
  region            = var.region

  name                = "app${var.name}"
  resource_group_name = var.resource_group_name
  kind                = var.app_service_plan_info.kind
  sku_tier            = var.app_service_plan_info.sku_tier
  sku_size            = var.app_service_plan_info.sku_size
}

module "secrets_from_keyvault" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_secrets_from_keyvault?ref=v0.0.24"

  key_vault_id = var.app_settings_secrets.key_vault_id
  secrets_map  = var.app_settings_secrets.map
}

resource "azurerm_app_service" "app_service" {
  name                = local.resource_name
  resource_group_name = var.resource_group_name
  location            = var.region
  app_service_plan_id = module.app_service_plan.id
  enabled             = var.app_enabled
  https_only          = var.https_only
  client_cert_enabled = var.client_cert_enabled

  site_config {
    min_tls_version = "1.2"

    dynamic "ip_restriction" {
      for_each = var.ip_addresses

      content {
        ip_address = ip_restriction.value
      }
    }
  }

  app_settings = merge(
    {
      APPINSIGHTS_INSTRUMENTATIONKEY = var.application_insights_instrumentation_key
    },
    var.app_settings,
    module.secrets_from_keyvault.secrets_with_value
  )

  tags = {
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [
      site_config[0].virtual_network_name,
    ]
  }
}

// Add the app_service to a subnet
module "subnet" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_subnet?ref=v0.0.24"

  global_prefix     = var.global_prefix
  environment       = var.environment
  environment_short = var.environment_short
  region            = var.region

  name                 = "app${var.name}"
  resource_group_name  = var.virtual_network_info.resource_group_name
  virtual_network_name = var.virtual_network_info.name
  address_prefix       = var.virtual_network_info.subnet_address_prefix

  delegation = {
    name = "default"

    service_delegation = {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "app_service_virtual_network_swift_connection" {
  app_service_id = azurerm_app_service.app_service.id
  subnet_id      = module.subnet.id
}

# Enable diagnostics data for the app_service
data "azurerm_monitor_diagnostic_categories" "app_service" {
  resource_id = azurerm_app_service.app_service.id
}

resource "azurerm_monitor_diagnostic_setting" "app_service" {
  count                      = var.log_analytics_workspace_id == null ? 0 : 1
  name                       = local.diagnostic_name
  target_resource_id         = azurerm_app_service.app_service.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.app_service.logs
    iterator = lg

    content {
      category = lg.value
      enabled  = true

      retention_policy {
        enabled = true
        days    = var.diagnostic_logs_retention
      }
    }
  }

  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.app_service.metrics
    iterator = mt

    content {
      category = mt.value
      enabled  = true

      retention_policy {
        enabled = true
        days    = var.diagnostic_logs_retention
      }
    }
  }
}

