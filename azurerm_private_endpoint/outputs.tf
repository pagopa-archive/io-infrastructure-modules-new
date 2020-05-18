output "id" {
  value = azurerm_private_endpoint.private_endpoint.id
}

output "name" {
  description = "The name of the private endpoint."
  value       = azurerm_private_endpoint.private_endpoint.name
}

output "private_ip_address" {
  value       = azurerm_private_endpoint.private_endpoint.private_service_connection.*.private_ip_address
  description = "The private ip addresses associated to the endpoint"
}
