provider "azurerm" {
  version = "=1.44.0"
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

data "azurerm_key_vault_secret" "secret_sas_url" {
  count        = var.application_logs == null ? 0 : 1
  name         = var.application_logs.key_vault_secret_sas_url
  key_vault_id = var.application_logs.key_vault_id
}

module "secrets_from_keyvault" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_secrets_from_keyvault?ref=v0.0.24"

  key_vault_id = var.app_settings_secrets.key_vault_id
  secrets_map  = var.app_settings_secrets.map
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

resource "azurerm_app_service" "app_service" {
  name                = local.resource_name
  resource_group_name = var.resource_group_name
  location            = var.region
  app_service_plan_id = module.app_service_plan.id
  enabled             = var.app_enabled
  https_only          = var.https_only
  client_cert_enabled = var.client_cert_enabled

  site_config {
    always_on       = var.always_on
    min_tls_version = "1.2"

    dynamic "ip_restriction" {
      for_each = var.allowed_ips
      iterator = ip

      content {
        ip_address = ip.value
      }
    }

    dynamic "ip_restriction" {
      for_each = var.allowed_subnets
      iterator = subnet

      content {
        virtual_network_subnet_id = subnet.value
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

  logs {

    dynamic "application_logs" {
      for_each = var.application_logs == null ? [] : ["dummy"]

      content {
        azure_blob_storage {
          sas_url           = data.azurerm_key_vault_secret.secret_sas_url[0].value
          level             = var.application_logs.level
          retention_in_days = var.application_logs.retention_in_days
        }
      }
    }
  }

  tags = {
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [
      site_config[0].virtual_network_name,
    ]
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "app_service_virtual_network_swift_connection" {
  count = var.subnet_id == null ? 0 : 1

  app_service_id = azurerm_app_service.app_service.id
  subnet_id      = var.subnet_id
}
