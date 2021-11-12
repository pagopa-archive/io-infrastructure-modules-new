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

resource "azurerm_route_table" "route_table" {
  name                          = local.resource_name
  location                      = var.region
  resource_group_name           = var.resource_group_name
  disable_bgp_route_propagation = var.disable_bgp_route_propagation

  dynamic "route" {
    for_each = var.routes
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_in_ip_address
    }
  }

  tags = {
    environment = var.environment
  }
}

resource "azurerm_subnet_route_table_association" "route_table_association" {
  subnet_id      = var.subnet_id
  route_table_id = azurerm_route_table.route_table.id
}
