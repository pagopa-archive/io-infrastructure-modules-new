output "id" {
  value = azurerm_private_dns_zone_virtual_network_link.private_dns_zone_virtual_network_link.*.id
}

output "name" {
  description = "The name of the privae dns."
  value       = azurerm_private_dns_zone_virtual_network_link.private_dns_zone_virtual_network_link.*.name
}
