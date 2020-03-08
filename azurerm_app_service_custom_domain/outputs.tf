output "binding_id" {
  value = azurerm_app_service_custom_hostname_binding.hostname_binding.id
}

output "hostname" {
  value = azurerm_app_service_custom_hostname_binding.hostname_binding.hostname
}
