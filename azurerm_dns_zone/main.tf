provider "azurerm" {
  version = "=2.4.0"
  features {}
}

terraform {
  backend "azurerm" {}
}

# New infrastructure
resource "azurerm_dns_zone" "dns_zone" {
  name                = var.name
  resource_group_name = var.resource_group_name

  tags = {
    environment = var.environment
  }
}
