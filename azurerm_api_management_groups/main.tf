provider "azurerm" {
  version = "=2.18.0"
  features {}
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

resource "azurerm_api_management_group" "api_management_group" {
  for_each = {
    for group in var.groups :
    group.name => {
      name         = group.name
      display_name = group.display_name
    }
  }

  resource_group_name = var.resource_group_name
  api_management_name = var.api_management_name
  name                = each.value.name
  display_name        = each.value.display_name
}
