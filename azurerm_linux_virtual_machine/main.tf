provider "azurerm" {
  version = "=2.0.0"
  features {}
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

resource "azurerm_network_interface" "network_interface" {
  name                = "${var.name}-nic"
  location            = var.region
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "snet-${var.name}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "virtual_machine" {
  name                = local.resource_name
  location            = var.region
  resource_group_name = var.resource_group_name

  network_interface_ids = [
    azurerm_network_interface.network_interface.id,
  ]

  admin_username = var.admin_username
  admin_password = var.admin_password

  disable_password_authentication = var.admin_password == null ? true : false

  size = var.size

  dynamic "source_image_reference" {
    for_each = var.source_image_reference
    content {
      publisher = source_image_reference.value["publisher"]
      offer     = source_image_reference.value["offer"]
      sku       = source_image_reference.value["sku"]
      version   = source_image_reference.value["version"]
    }
  }

  os_disk {
    name                      = var.os_disk.name
    caching                   = var.os_disk.caching
    storage_account_type      = var.os_disk.storage_account_type
    disk_encryption_set_id    = var.os_disk.disk_encryption_set_id
    disk_size_gb              = var.os_disk.disk_size_gb
    write_accelerator_enabled = var.os_disk.write_accelerator_enabled
  }

  dynamic "admin_ssh_key" {
    for_each = var.admin_ssh_key
    content {
      username   = admin_ssh_key.value["username"]
      public_key = admin_ssh_key.value["public_key"]
    }
  }


  tags = {
    environment = var.environment
  }
}