terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

resource "azurerm_management_lock" "management_lock" {
  name       = local.resource_name
  scope      = var.scope
  lock_level = var.lock_level
  notes      = var.notes
}
