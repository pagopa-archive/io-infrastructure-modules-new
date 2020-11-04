output "id" {
  value = azurerm_storage_account.storage_account.id
}

output "primary_connection_string" {
  value     = azurerm_storage_account.storage_account.primary_connection_string
  sensitive = true
}

output "primary_access_key" {
  value     = azurerm_storage_account.storage_account.primary_access_key
  sensitive = true
}

output "primary_blob_host" {
  value = azurerm_storage_account.storage_account.primary_blob_host
}

output "primary_web_host" {
  value = azurerm_storage_account.storage_account.primary_web_host
}

output "primary_web_endpoint" {
  value = azurerm_storage_account.storage_account.primary_web_endpoint
}

output "fqdn" {
  value = var.dns_cname_record == null ? null : azurerm_dns_cname_record.dns_cname_record[0].fqdn
}

output "resource_name" {
  value = local.resource_name
}
