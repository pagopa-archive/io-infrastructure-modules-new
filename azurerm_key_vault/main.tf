provider "azurerm" {
  version = "=1.42.0"
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

  // TODO: Create PR for terraform-provider-azurerm project to enable soft_delete flag on key_vault

  tags = {
    environment = var.environment
  }
}
