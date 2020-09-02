provider "azurerm" {
  version = "=2.18.0"
  features {}
}

terraform {
  backend "azurerm" {}
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_virtual_network_link" {
  count                 = var.module_disabled ? 0 : 1
  name                  = var.name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = var.private_dns_zone_name
  virtual_network_id    = var.virtual_network_id
  registration_enabled  = var.registration_enabled

  tags = {
    environment = var.environment
  }
}
