provider "azurerm" {
  version = "=2.22.0"
  features {}
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

resource "azurerm_eventhub_namespace" "eventhub_ns" {
  name                     = local.evhns_resource_name
  location                 = var.region
  resource_group_name      = var.resource_group_name
  sku                      = var.sku
  capacity                 = var.capacity
  auto_inflate_enabled     = var.auto_inflate_enabled
  maximum_throughput_units = var.auto_inflate_enabled ? var.maximum_throughput_units : null

  dynamic "network_rulesets" {
    for_each = var.network_rulesets
    content {
      default_action = network_rulesets.value["default_action"]
      # virtual_network_rule {} # optional one ore more
      dynamic "virtual_network_rule" {
        for_each = network_rulesets.value["virtual_network_rule"]
        content {
          subnet_id                                       = virtual_network_rule.value["subnet_id"]
          ignore_missing_virtual_network_service_endpoint = virtual_network_rule.value["ignore_missing_virtual_network_service_endpoint"]
        }
      }
      dynamic "ip_rule" {
        for_each = network_rulesets.value["ip_rule"]
        content {
          ip_mask = ip_rule.value["ip_mask"]
          action  = ip_rule.value["action"]
        }
      }
    }
  }

  tags = {
    environment = var.environment
  }
}

resource "azurerm_eventhub" "eventhub" {
  count               = length(var.eventhubs)
  name                = var.eventhubs[count.index].name
  namespace_name      = azurerm_eventhub_namespace.eventhub_ns.name
  resource_group_name = var.resource_group_name
  partition_count     = var.eventhubs[count.index].partition_count
  message_retention   = var.eventhubs[count.index].message_retention
}

resource "azurerm_eventhub_authorization_rule" "eventhub_rule" {
  count               = length(var.eventhub_authorization_rules)
  name                = var.eventhub_authorization_rules[count.index].name
  namespace_name      = azurerm_eventhub_namespace.eventhub_ns.name
  resource_group_name = var.resource_group_name
  eventhub_name       = var.eventhub_authorization_rules[count.index].eventhub_name
  listen              = var.eventhub_authorization_rules[count.index].listen
  send                = var.eventhub_authorization_rules[count.index].send
  manage              = var.eventhub_authorization_rules[count.index].manage
}
