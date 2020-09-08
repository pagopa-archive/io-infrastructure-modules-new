provider "azurerm" {
  version = "=2.22.0"
  features {}
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

resource "azurerm_user_assigned_identity" "user_assigned_identity"{
  name                = local.resource_name
  resource_group_name = var.resource_group_name
  location            = var.region

  tags = {
    environment = var.environment
  }
}
