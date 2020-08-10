provider "azurerm" {
  version = "=2.22.0"
  features {}
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

data "azurerm_key_vault_secret" "certificate_secret" {
  name         = var.custom_domains.certificate_name
  key_vault_id = var.custom_domains.key_vault_id
}

module "secrets_from_keyvault" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_secrets_from_keyvault?ref=v2.0.33"

  key_vault_id = var.named_values_secrets.key_vault_id
  secrets_map  = var.named_values_secrets.map
}

module "subnet" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_subnet?ref=v2.0.33"

  global_prefix     = var.global_prefix
  environment       = var.environment
  environment_short = var.environment_short
  region            = var.region

  name                 = "apim${var.name}"
  resource_group_name  = var.virtual_network_info.resource_group_name
  virtual_network_name = var.virtual_network_info.name
  address_prefix       = var.virtual_network_info.subnet_address_prefix

  service_endpoints = [
    "Microsoft.Web"
  ]
}

resource "azurerm_api_management" "api_management" {
  name                      = local.resource_name
  resource_group_name       = var.resource_group_name
  location                  = var.region
  publisher_name            = var.publisher_name
  publisher_email           = var.publisher_email
  notification_sender_email = var.notification_sender_email
  sku_name                  = var.sku_name

  identity {
    type = "SystemAssigned"
  }

  virtual_network_type = "Internal"
  virtual_network_configuration {
    subnet_id = module.subnet.id
  }

  hostname_configuration {
    dynamic proxy {
      for_each = toset(var.custom_domains.domains)
      iterator = domain

      content {
        default_ssl_binding = domain.value.default
        host_name           = domain.value.name
        key_vault_id        = data.azurerm_key_vault_secret.certificate_secret.id
      }
    }
  }

  tags = {
    environment = var.environment
  }
}

resource "azurerm_api_management_logger" "api_management_logger" {
  name                = "logger"
  api_management_name = azurerm_api_management.api_management.name
  resource_group_name = var.resource_group_name

  application_insights {
    instrumentation_key = var.application_insights_instrumentation_key
  }
}

resource "azurerm_api_management_property" "api_management_property" {
  for_each = merge(var.named_values_map, module.secrets_from_keyvault.secrets_with_value)

  name                = each.key
  api_management_name = azurerm_api_management.api_management.name
  resource_group_name = var.resource_group_name
  display_name        = each.key
  value               = each.value
  secret              = true
}
