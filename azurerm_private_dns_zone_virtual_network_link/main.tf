terraform {
  required_version = ">= 0.14.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.84.0"
    }
  }
  backend "azurerm" {}
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_virtual_network_link" {
  name                  = var.name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = var.private_dns_zone_name
  virtual_network_id    = var.virtual_network_id
  registration_enabled  = var.registration_enabled

  tags = {
    environment = var.environment
  }
}
