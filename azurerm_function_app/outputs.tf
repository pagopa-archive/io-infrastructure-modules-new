output "id" {
  value = azurerm_function_app.function_app.id
}

output "name" {
  value = var.name
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

output "app_service_plan_id" {
  value = module.app_service_plan.id
}

output "storage_account" {
  value = {
    name               = module.storage_account.resource_name
    primary_access_key = module.storage_account.primary_access_key
  }
}

output "resource_name" {
  value = local.resource_name
}
