output "id" {
  value = azurerm_app_configuration.this.id
}

output "endpoint" {
  value = azurerm_app_configuration.this.endpoint
}

output "primary_read_key" {
  value     = azurerm_app_configuration.this.primary_read_key
  sensitive = true
}

output "primary_write_key" {
  value     = azurerm_app_configuration.this.primary_write_key
  sensitive = true
}

output "secondary_read_key" {
  value     = azurerm_app_configuration.this.secondary_read_key
  sensitive = true
}

output "secondary_write_key" {
  value     = azurerm_app_configuration.this.secondary_write_key
  sensitive = true
}
