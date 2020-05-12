output "id" {
  value = azurerm_private_endpoint.private_endpoint.id
}

output "name" {
  description = "The name of the private endpoint."
  value       = azurerm_private_endpoint.private_endpoint.name
}

output "private_dns_zone_id" {
  description = "The id of the privae dns zone."
  value       = module.private_dns_zone.*.id
}

output "private_dns_zone_name" {
  description = "The name of the privae dns zone."
  value       = module.private_dns_zone.*.name
}
