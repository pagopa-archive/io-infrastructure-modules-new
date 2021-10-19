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
