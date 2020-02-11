output "notification_hub_namespace_name" {
  description = "The name of the notification hub namespace."
  value       = local.ntfns_resource_name
}

output "notification_hub_name" {
  description = "The name of the notification hub."
  value       = local.resource_name
}

output "notification_hub_id" {
  value = azurerm_notification_hub.notification_hub.id
}
