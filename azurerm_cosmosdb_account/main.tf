provider "azurerm" {
  version = "~>1.42"
}

terraform {
  backend "azurerm" {}
}

# New infrastructure
resource "azurerm_cosmosdb_account" "cosmosdb_account" {
  name                      = local.resource_name
  location                  = var.region
  resource_group_name       = var.resource_group_name
  offer_type                = var.offer_type
  kind                      = var.kind
  enable_automatic_failover = true

  dynamic "geo_location" {
    for_each = var.geo_location != "" ? var.geo_location : []

    content {
      prefix            = "${local.resource_name}-${geo_location.value["prefix"]}"
      location          = geo_location.value["location"]
      failover_priority = geo_location.value["failover_priority"]
    }
  }

  dynamic "consistency_policy" {
    for_each = var.consistency_policy != "" ? var.consistency_policy : []

    content {
      consistency_level       = consistency_policy.value["consistency_level"]
      max_interval_in_seconds = consistency_policy.value["max_interval_in_seconds"]
      max_staleness_prefix    = consistency_policy.value["max_staleness_prefix"]
    }
  }

  # Firewall settings
  is_virtual_network_filter_enabled = var.is_virtual_network_filter_enabled

  dynamic "virtual_network_rule" {
    for_each = var.virtual_network_rule != "" ? var.virtual_network_rule : []

    content {
      id = virtual_network_rule.value
    }
  }
}

