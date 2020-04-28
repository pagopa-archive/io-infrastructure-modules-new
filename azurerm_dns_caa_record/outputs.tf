output "id" {
  description = "The DNS CAA Record ID."
  value       = azurerm_dns_caa_record.dns_caa_record.id
}

output "name" {
  description = "The name of the DNS CAA Record."
  value       = var.name
}

output "fqdn" {
  description = "The FQDN of the DNS CAA Record."
  value       = azurerm_dns_caa_record.dns_caa_record.fqdn
}
