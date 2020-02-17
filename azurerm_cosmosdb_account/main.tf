provider "azurerm" {
  version = "~>1.44"
}

terraform {
  backend "azurerm" {}
}

// New infrastructure
resource "azurerm_cosmosdb_account" "cosmosdb_account" {
  name                      = local.resource_name
  location                  = var.region
  resource_group_name       = var.resource_group_name
  offer_type                = var.offer_type
  kind                      = var.kind
  enable_automatic_failover = true

  dynamic "geo_location" {
    for_each = var.geo_locations
    iterator = geo

    content {
      prefix            = "${local.resource_name}-${geo.value["prefix"]}"
      location          = geo.value["location"]
      failover_priority = geo.value["failover_priority"]
    }
  }

  dynamic "consistency_policy" {
    for_each = var.consistency_policy
    iterator = consistency

    content {
      consistency_level       = consistency.value["consistency_level"]
      max_interval_in_seconds = consistency.value["max_interval_in_seconds"]
      max_staleness_prefix    = consistency.value["max_staleness_prefix"]
    }
  }

  dynamic "capabilities" {
    for_each = var.capabilities

    content {
      name = capabilities.value
    }
  }  

  // Virtual network settings
  is_virtual_network_filter_enabled = var.is_virtual_network_filter_enabled

  dynamic "virtual_network_rule" {
    for_each = var.allowed_virtual_network_subnet_ids
    iterator = subnet_id

    content {
      id = subnet_id.value
    }
  }

  // IP filtering
  ip_range_filter = var.ip_range

}


