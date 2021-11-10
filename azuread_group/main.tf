terraform {
  required_version = ">= 0.14.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.84.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=0.7.0"
    }
  }
  backend "azurerm" {}
}

resource "azuread_group" "group" {
  name = local.resource_name
}
