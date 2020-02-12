output "domain_name" {
  description = "The full DNS name of the new zone."
  value       = var.dns_zone_name
}

output "id" {
  description = "The full DNS name of the new zone."
  value       = azurerm_dns_zone.dns_zone.id
}

output "nameservers" {
  description = "The list of name servers used for the zone."
  value       = azurerm_dns_zone.dns_zone.name_servers
}
