provider "azurerm" {
  version = "=1.42.0"
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

resource "azurerm_cosmosdb_sql_container" "cosmosdb_sql_container" {
  name                = var.name
  resource_group_name = var.resource_group_name

  account_name       = var.account_name
  database_name      = var.database_name
  partition_key_path = var.partition_key_path
  throughput         = var.throughput
  default_ttl        = var.default_ttl

  unique_key {
    paths = var.unique_key_paths
  }

}

