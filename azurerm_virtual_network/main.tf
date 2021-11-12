terraform {
  required_version = ">= 0.14.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.46.1"
    }
  }
  backend "azurerm" {}
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = local.resource_name
  resource_group_name = var.resource_group_name
  location            = var.region
  address_space       = var.address_space

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan == null ? [] : ["dummy"]

    content {
      id     = var.ddos_protection_plan.id
      enable = var.ddos_protection_plan.enable
    }
  }

  tags = {
    environment = var.environment
  }
}

module "lock" {
  count             = var.lock != null ? 1 : 0
  source            = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_management_lock?ref=v3.0.11"
  global_prefix     = var.global_prefix
  environment_short = var.environment_short
  name              = var.lock.name
  scope             = azurerm_virtual_network.virtual_network.id
  lock_level        = var.lock.lock_level
  notes             = var.lock.notes
}
