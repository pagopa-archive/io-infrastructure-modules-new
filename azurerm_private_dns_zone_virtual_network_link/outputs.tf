output "id" {
  value = var.module_disabled ? null : azurerm_private_dns_zone_virtual_network_link.private_dns_zone_virtual_network_link[0].id
}

output "name" {
  description = "The name of the privae dns."
  value       = var.module_disabled ? null : azurerm_private_dns_zone_virtual_network_link.private_dns_zone_virtual_network_link[0].name
}
