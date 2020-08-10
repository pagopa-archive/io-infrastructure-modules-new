provider "azurerm" {
  version = "=2.22.0"
  features {}
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

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan == null ? [] : ["dummy"]

    content {
      id     = var.ddos_protection_plan.id
      enable = var.ddos_protection_plan.enable
    }
  }

  tags = {
    environment = var.environment
  }
}
