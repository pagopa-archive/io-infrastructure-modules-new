output "name" {
  description = "The name of the notification hub namespace."
  value       = local.resource_name
}

output "namespace_servicebus_endpoint" {
  description = "The ServiceBus Endpoint for this Notification Hub Namespace."
  value       = azurerm_notification_hub_namespace.notification_hub_ns.servicebus_endpoint
}
