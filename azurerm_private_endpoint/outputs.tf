output "id" {
  value = azurerm_private_endpoint.private_endpoint.id
}

output "name" {
  description = "The name of the private endpoint."
  value       = azurerm_private_endpoint.private_endpoint.name
}
