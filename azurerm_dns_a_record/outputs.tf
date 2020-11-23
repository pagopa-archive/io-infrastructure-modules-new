output "id" {
  description = "The DNS A Record ID."
  value       = azurerm_dns_a_record.dns_a_record.id
}

output "name" {
  description = "The name of the DNS A Record."
  value       = azurerm_dns_a_record.dns_a_record.name
}

output "fqdn" {
  description = "The FQDN of the DNS A Record."
  value       = azurerm_dns_a_record.dns_a_record.fqdn
}
