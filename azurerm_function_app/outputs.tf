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
  value     = data.azurerm_function_app_host_keys.app_host_keys.default_function_key
  sensitive = true
}

output "master_key" {
  value     = data.azurerm_function_app_host_keys.app_host_keys.master_key
  sensitive = true
}

output "subnet_id" {
  value = length(module.subnet) > 0 ? module.subnet[0].id : null
}

output "app_service_plan_id" {
  value = length(module.app_service_plan) > 0 ? module.app_service_plan[0].id : null
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
