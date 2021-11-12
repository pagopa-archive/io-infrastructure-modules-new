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

module "secrets_from_keyvault" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_secrets_from_keyvault?ref=v3.0.11"

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
        virtual_network_subnet_id = subnet.value
      }
    }

    dynamic "cors" {
      for_each = var.cors != null ? [var.cors] : []
      content {
        allowed_origins = cors.value.allowed_origins
      }
    }

    auto_swap_slot_name = var.auto_swap_slot_name
    health_check_path   = var.health_check_path != null ? var.health_check_path : null
  }

  app_settings = merge(
    {
      APPINSIGHTS_INSTRUMENTATIONKEY = var.application_insights_instrumentation_key
      # No downtime on slots swap
      WEBSITE_ADD_SITENAME_BINDINGS_IN_APPHOST_CONFIG = 1
      # default value for health_check_path, override it in var.app_settings if needed
      WEBSITE_HEALTHCHECK_MAXPINGFAILURES = var.health_check_path != null ? var.health_check_maxpingfailures : null
      # https://docs.microsoft.com/en-us/samples/azure-samples/azure-functions-private-endpoints/connect-to-private-endpoints-with-azure-functions/
      # https://github.com/Azure/Azure-Functions/issues/1349#issuecomment-747476420
      DURABLE_FUNCTION_STORAGE_CONNECTION_STRING = var.storage_account_durable_function_connection_string
      INTERNAL_STORAGE_CONNECTION_STRING         = var.storage_account_durable_function_connection_string
      SLOT_TASK_HUBNAME                          = "${title(var.name)}TaskHub"
      WEBSITE_RUN_FROM_PACKAGE                   = 1
      WEBSITE_VNET_ROUTE_ALL                     = 1
      WEBSITE_DNS_SERVER                         = "168.63.129.16"
      # this app settings is required to solve the issue:
      # https://github.com/terraform-providers/terraform-provider-azurerm/issues/10499
      WEBSITE_CONTENTSHARE = "${var.name}-content"
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
