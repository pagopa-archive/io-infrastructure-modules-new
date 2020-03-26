output "source_id" {
  value = azurerm_virtual_network_peering.virtual_network_peering_source.id
}

output "target_id" {
  value = azurerm_virtual_network_peering.virtual_network_peering_target.id
}

output "source_name" {
  value = azurerm_virtual_network_peering.virtual_network_peering_source.name
}

output "target_name" {
  value = azurerm_virtual_network_peering.virtual_network_peering_target.name
}
