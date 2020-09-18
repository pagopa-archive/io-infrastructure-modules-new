provider "azurerm" {
  version = "=2.22.0"
  features {}
}

resource "azurerm_resource_group" "resource_group" {
  name     = local.resource_name
  location = var.region

  tags = {
    environment = var.environment
  }
}
