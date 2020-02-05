
output "id" {
  value = azurerm_public_ip.public_ip.id
}

output "ip_address" {
  value = azurerm_public_ip.public_ip.ip_address
}

output "resource_name" {
  value = local.resource_name
}

