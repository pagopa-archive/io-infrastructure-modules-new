output "id" {
  value = azurerm_virtual_network.virtual_network.id
}

output "resource_group_name" {
  value = var.resource_group_name
}

output "resource_name" {
  value = local.resource_name
}

output "lock_id" {
  value = var.lock != null ? module.lock[0].id : null
}
