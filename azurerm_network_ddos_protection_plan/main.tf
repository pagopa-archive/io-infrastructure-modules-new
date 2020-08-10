provider "azurerm" {
  version = "=2.22.0"
  features {}
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

resource "azurerm_network_ddos_protection_plan" "network_ddos_protection_plan" {
  name                = local.resource_name
  location            = var.region
  resource_group_name = var.resource_group_name

  tags = {
    environment = var.environment
  }
}
