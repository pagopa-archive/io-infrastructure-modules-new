output "id" {
  value = azurerm_linux_virtual_machine.linux_virtual_machine.id
}

output "name" {
  value = azurerm_linux_virtual_machine.linux_virtual_machine.name
}

output "admin_username" {
  value     = azurerm_linux_virtual_machine.linux_virtual_machine.admin_username
  sensitive = true
}

output "private_ip_address" {
  value = azurerm_linux_virtual_machine.linux_virtual_machine.private_ip_address
}

output "public_ip_address" {
  value = azurerm_public_ip.public_ip[*].ip_address
}

