terraform {
  required_version = ">= 0.14.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.46.1"
    }
  }
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

  dynamic "unique_key" {
    for_each = var.unique_key_paths
    content {
      paths = [unique_key.value]
    }
  }

  dynamic "autoscale_settings" {
    for_each = var.autoscale_settings != null ? [var.autoscale_settings] : []
    content {
      max_throughput = autoscale_settings.value.max_throughput
    }
  }

}
