output "name" {
  description = "The name of the CosmosDB created."
  value       = local.resource_name
}

output "endpoint" {
  description = "The endpoint used to connect to the CosmosDB account."
  value       = azurerm_cosmosdb_account.cosmosdb_account.endpoint
}

output "write_endpoints" {
  description = "A list of write endpoints available for this CosmosDB account."
  value       = azurerm_cosmosdb_account.cosmosdb_account.write_endpoints
}

output "read_endpoints" {
  description = "A list of read endpoints available for this CosmosDB account."
  value       = azurerm_cosmosdb_account.cosmosdb_account.read_endpoints
}

output "primary_master_key" {
  value     = azurerm_cosmosdb_account.cosmosdb_account.primary_master_key
  sensitive = true
}

output "primary_readonly_master_key" {
  value     = azurerm_cosmosdb_account.cosmosdb_account.primary_readonly_master_key
  sensitive = true
}
