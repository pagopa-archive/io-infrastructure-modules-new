output "id" {
  value = azurerm_notification_hub.notification_hub.id
}

output "name" {
  description = "The name of the notification hub."
  value       = local.resource_name
}

output "namespace_name" {
  description = "The name of the notification hub namespace."
  value       = local.ntfns_resource_name
}

output "namespace_servicebus_endpoint" {
  description = "The ServiceBus Endpoint for this Notification Hub Namespace."
  value       = azurerm_notification_hub.notification_hub.servicebus_endpoint
}