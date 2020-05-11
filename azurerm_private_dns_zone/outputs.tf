output "id" {
  value = azurerm_private_dns_zone.private_dns_zone.*.id
}

output "name" {
  description = "The name of the privae dns."
  value       = azurerm_private_dns_zone.private_dns_zone.*.name
}
