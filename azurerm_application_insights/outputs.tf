output "name" {
  value = azurerm_application_insights.application_insights.name
}

output "id" {
  value = azurerm_application_insights.application_insights.id
}

output "app_id" {
  value = azurerm_application_insights.application_insights.app_id
}

output "instrumentation_key" {
  value     = azurerm_application_insights.application_insights.instrumentation_key
  sensitive = true
}


