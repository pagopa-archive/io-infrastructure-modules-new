provider "azurerm" {
  version = "=2.22.0"
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

module "secrets_from_keyvault" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_secrets_from_keyvault?ref=v2.0.37"

  key_vault_id = var.app_settings_secrets.key_vault_id
  secrets_map  = var.app_settings_secrets.map
}

resource "azurerm_function_app_slot" "function_app_slot" {
  name                       = var.name
  resource_group_name        = var.resource_group_name
  location                   = var.region
  version                    = var.runtime_version
  function_app_name          = var.function_app_resource_name
  app_service_plan_id        = var.app_service_plan_id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key

  site_config {
    min_tls_version           = "1.2"
    ftps_state                = "Disabled"
    pre_warmed_instance_count = var.pre_warmed_instance_count

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
        subnet_id = subnet.value
      }
    }
  }

  app_settings = merge(
    {
      APPINSIGHTS_INSTRUMENTATIONKEY = var.application_insights_instrumentation_key
      # No downtime on slots swap
      WEBSITE_ADD_SITENAME_BINDINGS_IN_APPHOST_CONFIG = 1
    },
    var.app_settings,
    module.secrets_from_keyvault.secrets_with_value
  )

  enable_builtin_logging = false

  tags = {
    environment = var.environment
  }
}

resource "azurerm_app_service_slot_virtual_network_swift_connection" "app_service_slot_virtual_network_swift_connection" {
  count          = var.subnet_id == null ? 0 : 1
  app_service_id = var.function_app_id
  subnet_id      = var.subnet_id
  slot_name      = azurerm_function_app_slot.function_app_slot.name

}

resource "azurerm_template_deployment" "function_keys" {
  count = var.export_default_key ? 1 : 0

  name = "javafunckeys"
  parameters = {
    functionApp = azurerm_function_app_slot.function_app_slot.name
  }
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"

  template_body = <<BODY
  {
      "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
      "contentVersion": "1.0.0.0",
      "parameters": {
          "functionApp": {"type": "string", "defaultValue": ""}
      },
      "variables": {
          "functionAppId": "[resourceId('Microsoft.Web/sites', parameters('functionApp'))]"
      },
      "resources": [
      ],
      "outputs": {
          "functionkey": {
              "type": "string",
              "value": "[listkeys(concat(variables('functionAppId'), '/host/default'), '2018-11-01').functionKeys.default]"                                                                                }
      }
  }
  BODY
}
