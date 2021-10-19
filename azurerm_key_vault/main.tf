terraform {
  required_version = ">= 0.14.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.78.0"
    }
  }
  backend "azurerm" {}
}

resource "azurerm_key_vault" "key_vault" {
  name                = local.resource_name
  location            = var.region
  resource_group_name = var.resource_group_name
  tenant_id           = local.tenant_id
  sku_name            = var.sku_name

  tags = {
    environment = var.environment
  }
}
