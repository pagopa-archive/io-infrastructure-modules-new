provider "azurerm" {
  version = "=1.42.0"
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = local.resource_name
  resource_group_name = var.resource_group_name
  location            = var.region
  address_space       = var.address_space

  tags = {
    environment = var.environment
  }
}
