provider "azurerm" {
  version = "=1.44.0"
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

module "subnet" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_subnet?ref=v0.0.34"

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

  virtual_network_type = "Internal"
  virtual_network_configuration {
    subnet_id = module.subnet.id
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
  for_each = var.named_values_map

  name                = each.key
  api_management_name = azurerm_api_management.api_management.name
  resource_group_name = var.resource_group_name
  display_name        = each.key
  value               = each.value
  secret              = true
}
