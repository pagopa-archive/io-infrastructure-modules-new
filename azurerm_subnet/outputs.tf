output "id" {
  value = var.module_disabled ? null : azurerm_subnet.subnet[0].id
}

output "name" {
  value = var.module_disabled ? null : azurerm_subnet.subnet[0].name
}
