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

resource "azurerm_management_lock" "management_lock" {
  name       = local.resource_name
  scope      = var.scope
  lock_level = var.lock_level
  notes      = var.notes
}
