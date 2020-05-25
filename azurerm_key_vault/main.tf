provider "azurerm" {
  version = "=2.11.0"
  features {}
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

resource "azurerm_key_vault" "key_vault" {
  name                = local.resource_name
  location            = var.region
  resource_group_name = var.resource_group_name
  tenant_id           = local.tenant_id
  sku_name            = var.sku_name
  soft_delete_enabled = var.soft_delete_enabled

  tags = {
    environment = var.environment
  }
}
