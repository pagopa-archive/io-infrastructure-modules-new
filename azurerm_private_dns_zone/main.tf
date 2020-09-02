provider "azurerm" {
  version = "=2.18.0"
  features {}
}

terraform {
  backend "azurerm" {}
}

resource "azurerm_private_dns_zone" "private_dns_zone" {
  count               = var.module_disabled ? 0 : 1
  name                = var.name
  resource_group_name = var.resource_group_name

  tags = {
    environment = var.environment
  }
}
