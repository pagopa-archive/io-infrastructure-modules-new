terraform {
  required_version = ">= 0.14.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.87.0"
    }
  }
  backend "azurerm" {}
}

resource "azurerm_cosmosdb_sql_database" "cosmosdb_sql_database" {
  name                = var.name
  resource_group_name = var.resource_group_name
  account_name        = var.account_name
  throughput          = var.throughput
}
