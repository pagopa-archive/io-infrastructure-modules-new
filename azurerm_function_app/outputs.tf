output "id" {
  value = azurerm_function_app.function_app.id
}

output "default_key" {
  value     = azurerm_template_deployment.function_keys.outputs.functionkey
  sensitive = true
}

output "subnet_id" {
  value = module.subnet.id
}

output "resource_name" {
  value = local.resource_name
}


