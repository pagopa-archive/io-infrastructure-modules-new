output "id" {
  value = azurerm_function_app_slot.function_app_slot.id
}

output "name" {
  value = azurerm_function_app_slot.function_app_slot.name
}

output "default_hostname" {
  value     = azurerm_function_app_slot.function_app_slot.default_hostname
  sensitive = true
}

output "possible_outbound_ip_addresses" {
  value = azurerm_function_app_slot.function_app_slot.possible_outbound_ip_addresses
}

output "default_key" {
  value     = var.export_default_key ? azurerm_template_deployment.function_keys[0].outputs.functionkey : null
  sensitive = true
}
