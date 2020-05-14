provider "azurerm" {
  version = "=2.9.0"
  features {}
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

resource "azurerm_subnet" "subnet" {
  count = var.module_disabled ? 0 : 1

  name                 = var.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefix       = var.address_prefix

  dynamic "delegation" {
    for_each = var.delegation == null ? [] : ["delegation"]
    content {
      name = var.delegation.name

      service_delegation {
        name    = var.delegation.service_delegation.name
        actions = var.delegation.service_delegation.actions
      }
    }
  }

  service_endpoints = var.service_endpoints

  enforce_private_link_endpoint_network_policies = var.enforce_private_link_endpoint_network_policies
}
