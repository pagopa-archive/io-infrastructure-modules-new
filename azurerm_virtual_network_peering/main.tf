provider "azurerm" {
  version = "=2.4.0"
  features {}
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

resource "azurerm_virtual_network_peering" "virtual_network_peering_source" {
  name                      = local.source_resource_name
  resource_group_name       = var.source_resource_group_name
  virtual_network_name      = var.source_virtual_network_name
  remote_virtual_network_id = var.target_remote_virtual_network_id

  allow_virtual_network_access = var.source_allow_virtual_network_access
  allow_forwarded_traffic      = var.source_allow_forwarded_traffic
  allow_gateway_transit        = var.source_allow_gateway_transit
  use_remote_gateways          = var.source_use_remote_gateways
}

resource "azurerm_virtual_network_peering" "virtual_network_peering_target" {
  name                      = local.target_resource_name
  resource_group_name       = var.target_resource_group_name != null ? var.target_resource_group_name : var.source_resource_group_name
  virtual_network_name      = var.target_virtual_network_name
  remote_virtual_network_id = var.source_remote_virtual_network_id

  allow_virtual_network_access = var.target_allow_virtual_network_access
  allow_forwarded_traffic      = var.target_allow_forwarded_traffic
  allow_gateway_transit        = var.target_allow_gateway_transit
  use_remote_gateways          = var.target_use_remote_gateways
}
