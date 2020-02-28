output "name" {
  value = var.name
}

output "fqdn" {
  value = azurerm_dns_cname_record.dns_cname_record.fqdn
}
