output "eventhub_namespace_name" {
  value = azurerm_eventhub_namespace.eventhub_ns.name
}

output "id" {
  value = azurerm_eventhub.eventhub[*].id
}

output "name" {
  value = azurerm_eventhub.eventhub[*].name
}

output "rule_ids" {
  value = azurerm_eventhub_authorization_rule.eventhub_rule[*].id
}

output "rule_names" {
  value = azurerm_eventhub_authorization_rule.eventhub_rule[*].name
}
