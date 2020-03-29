output "id" {
  value = azurerm_function_app.function_app.id
}

output "default_hostname" {
  value     = azurerm_function_app.function_app.default_hostname
  sensitive = true
}

output "possible_outbound_ip_addresses" {
  value = azurerm_function_app.function_app.possible_outbound_ip_addresses
}

output "default_key" {
  value     = var.export_default_key ? azurerm_template_deployment.function_keys[0].outputs.functionkey : null
  sensitive = true
}

output "subnet_id" {
  value = module.subnet.id
}

output "resource_name" {
  value = local.resource_name
}
