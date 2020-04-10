provider "azurerm" {
  version = "=2.4.0"
  features {}
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

data "azurerm_key_vault_secret" "allowed_ips_secret" {
  count = var.allowed_ips_secret == null ? 0 : 1

  name         = var.allowed_ips_secret.key_vault_secret
  key_vault_id = var.allowed_ips_secret.key_vault_id
}

data "azurerm_key_vault_secret" "secret_sas_url" {
  count        = var.application_logs == null ? 0 : 1
  name         = var.application_logs.key_vault_secret_sas_url
  key_vault_id = var.application_logs.key_vault_id
}

module "secrets_from_keyvault" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_secrets_from_keyvault?ref=v2.0.0"

  key_vault_id = var.app_settings_secrets.key_vault_id
  secrets_map  = var.app_settings_secrets.map
}

resource "azurerm_app_service_slot" "app_service_slot" {
  name                = var.name
  app_service_name    = var.app_service_name
  location            = var.region
  resource_group_name = var.resource_group_name
  app_service_plan_id = var.app_service_plan_id

  enabled    = var.app_enabled
  https_only = var.https_only

  site_config {
    always_on           = var.always_on
    min_tls_version     = "1.2"
    auto_swap_slot_name = var.auto_swap_slot_name

    dynamic "ip_restriction" {
      for_each = var.allowed_ips
      iterator = ip

      content {
        ip_address = ip.value
      }
    }

    dynamic "ip_restriction" {
      for_each = var.allowed_ips_secret == null ? [] : split(";", data.azurerm_key_vault_secret.allowed_ips_secret[0].value)
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
}

resource "azurerm_app_service_virtual_network_swift_connection" "app_service_virtual_network_swift_connection" {
  count = var.subnet_id == null ? 0 : 1

  app_service_id = azurerm_app_service_slot.app_service_slot.id
  subnet_id      = var.subnet_id
}
