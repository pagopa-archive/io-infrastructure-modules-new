terraform {
  required_version = ">= 0.14.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.78.0"
    }
  }
  backend "azurerm" {}
}

resource "azurerm_network_security_group" "network_security_group" {
  name                = local.network_security_group_name
  location            = var.region
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = var.security_rules
    content {
      name                         = security_rule.value.name
      description                  = security_rule.value.description
      priority                     = security_rule.value.priority
      direction                    = security_rule.value.direction
      access                       = security_rule.value.access
      protocol                     = security_rule.value.protocol
      source_port_range            = length(security_rule.value.source_port_ranges) == 1 ? security_rule.value.source_port_ranges[0] : null
      source_port_ranges           = length(security_rule.value.source_port_ranges) < 2 ? [] : security_rule.value.source_port_ranges
      destination_port_range       = length(security_rule.value.destination_port_ranges) == 1 ? security_rule.value.destination_port_ranges[0] : null
      destination_port_ranges      = length(security_rule.value.destination_port_ranges) < 2 ? [] : security_rule.value.destination_port_ranges
      source_address_prefixes      = security_rule.value.source_address_prefixes
      destination_address_prefixes = security_rule.value.destination_address_prefixes
    }
  }

  tags = {
    environment = var.environment
  }
}

resource "azurerm_public_ip" "public_ip" {
  count               = var.assign_public_ip ? 1 : 0
  name                = local.public_ip_name
  location            = var.region
  resource_group_name = var.resource_group_name
  allocation_method   = var.allocation_method

  tags = {
    environment = var.environment
  }
}

resource "azurerm_network_interface" "network_interface" {
  name                = "nic-${var.name}"
  location            = var.region
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "snet-${var.name}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.assign_public_ip ? azurerm_public_ip.public_ip[0].id : null
  }
}

resource "azurerm_network_interface_security_group_association" "network_interface_security_group_association" {
  network_interface_id      = azurerm_network_interface.network_interface.id
  network_security_group_id = azurerm_network_security_group.network_security_group.id
}

# Create virtual machine and Accept the agreement.
resource "azurerm_marketplace_agreement" "checkpoint" {
  count     = length(var.plans)
  publisher = var.plans[count.index].publisher
  offer     = var.source_image_reference[count.index].offer
  plan      = var.plans[count.index].plan
}

data "azurerm_key_vault_secret" "siem_vm_admin_password" {
  count        = var.key_vault_id == null ? 0 : 1
  name         = "siem-VM-ADMIN-PASSWORD"
  key_vault_id = var.key_vault_id
}

resource "azurerm_linux_virtual_machine" "linux_virtual_machine" {
  name                = local.resource_name
  location            = var.region
  resource_group_name = var.resource_group_name

  network_interface_ids = [
    azurerm_network_interface.network_interface.id,
  ]

  admin_username = var.admin_username
  admin_password = var.key_vault_id == null ? null : data.azurerm_key_vault_secret.siem_vm_admin_password[0].value

  disable_password_authentication = var.key_vault_id == null ? true : false

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

  dynamic "plan" {
    for_each = var.plans
    content {
      name      = plan.value["name"]
      product   = plan.value["product"]
      publisher = plan.value["publisher"]
    }
  }

  tags = {
    environment = var.environment
  }
}

resource "azurerm_dns_a_record" "dns_a_record" {

  count = var.dns_record != null ? 1 : 0

  name                = var.dns_record.name
  zone_name           = var.dns_record.zone_name
  resource_group_name = var.dns_record.zone_resource_group_name
  ttl                 = var.dns_record.ttl
  records = [
    azurerm_public_ip.public_ip[0].ip_address
  ]
}
