provider "azurerm" {
  version = "=2.11.0"
  features {}
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

resource "azurerm_storage_table" "storage_table" {
  name                 = var.name
  storage_account_name = var.storage_account_name
}
