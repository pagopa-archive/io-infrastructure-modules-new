terraform {
  backend "azurerm" {}
}

resource "azurerm_notification_hub_namespace" "notification_hub_ns" {
  name                = local.resource_name
  resource_group_name = var.resource_group_name
  location            = var.region
  namespace_type      = var.ntfns_namespace_type
  sku_name            = var.ntfns_sku_name
  enabled             = var.ntfns_enabled
}
