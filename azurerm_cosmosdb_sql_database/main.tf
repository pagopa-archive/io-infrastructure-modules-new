provider "azurerm" {
  version = "=2.4.0"
  features {}
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

resource "azurerm_cosmosdb_sql_database" "cosmosdb_sql_database" {
  name                = var.name
  resource_group_name = var.resource_group_name
  account_name        = var.account_name
  throughput          = var.throughput
}
