output "id" {
  value = azurerm_private_dns_a_record.private_dns_a_record.*.id
}

output "name" {
  description = "The name of the private dns record."
  value       = azurerm_private_dns_a_record.private_dns_a_record.*.name
}

output "fqdn" {
  description = "The FQDN of the DNS A Record."
  value       = azurerm_private_dns_a_record.private_dns_a_record.*.fqdn
}
