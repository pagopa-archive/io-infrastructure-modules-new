provider "azurerm" {
  version = "=2.4.0"
  features {}
}

terraform {
  backend "azurerm" {}
}

resource "azurerm_private_dns_zone" "private_dns_zone" {
  count               = var.name == null ? 0 : 1
  name                = var.name
  resource_group_name = var.resource_group_name

  tags = {
    environment = var.environment
  }
}
