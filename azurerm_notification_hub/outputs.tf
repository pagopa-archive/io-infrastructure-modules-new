output "id" {
  value = azurerm_notification_hub.notification_hub.id
}

output "name" {
  description = "The name of the notification hub."
  value       = local.resource_name
}
