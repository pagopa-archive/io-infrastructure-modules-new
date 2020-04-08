provider "azurerm" {
  version = "=2.4.0"
  features {}
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

resource "azurerm_resource_group" "resource_group" {
  name     = local.resource_name
  location = var.region

  tags = {
    environment = var.environment
  }
}
