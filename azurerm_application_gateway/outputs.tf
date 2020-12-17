output "id" {
  value = azurerm_application_gateway.application_gateway.id
}

output "name" {
  value = azurerm_application_gateway.application_gateway.name
}

output "subnet_id" {
  value = length(module.subnet) > 0 ? module.subnet[0].id : null
}
