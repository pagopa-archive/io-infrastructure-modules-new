output "id" {
  value = azurerm_app_service.app_service.id
}

output "subnet_id" {
  value = module.subnet.id
}

output "resource_name" {
  value = local.resource_name
}

output "default_site_hostname" {
  value = azurerm_app_service.app_service.default_site_hostname
}
