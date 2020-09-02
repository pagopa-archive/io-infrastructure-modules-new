output "id" {
  value = azurerm_logic_app_workflow.logic_app.id
}

output "name" {
  value = azurerm_logic_app_workflow.logic_app.name
}

output "access_endpoint" {
  value = azurerm_logic_app_workflow.logic_app.access_endpoint
}

output "connector_endpoint_ip_addresses" {
  value = azurerm_logic_app_workflow.logic_app.connector_endpoint_ip_addresses
}

output "connector_outbound_ip_addresses" {
  value = azurerm_logic_app_workflow.logic_app.connector_outbound_ip_addresses
}

output "workflow_endpoint_ip_addresses" {
  value = azurerm_logic_app_workflow.logic_app.workflow_endpoint_ip_addresses
}

output "workflow_outbound_ip_addresses" {
  value = azurerm_logic_app_workflow.logic_app.workflow_outbound_ip_addresses
}
