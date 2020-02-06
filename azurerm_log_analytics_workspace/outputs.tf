output "workspace_name" {
  description = "The name of the logs analytics workspace."
  value       = local.resource_name
}

output "id" {
  description = "The Log Analytics Workspace ID."
  value       = azurerm_log_analytics_workspace.log_analytics_workspace.id
}

output "primary_shared_key" {
  description = "The Primary shared key for the Log Analytics Workspace." 
  value       = azurerm_log_analytics_workspace.log_analytics_workspace.primary_shared_key
  sensitive   = true
}

output "workspace_id" {
  description = "The Workspace (or Customer) ID for the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.log_analytics_workspace.workspace_id
  sensitive   = true
}
