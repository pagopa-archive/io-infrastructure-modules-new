terraform {
  required_version = ">= 0.14.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.84.0"
    }
  }
  backend "azurerm" {}
}

resource "azurerm_user_assigned_identity" "user_assigned_identity" {
  name                = local.resource_name
  resource_group_name = var.resource_group_name
  location            = var.region

  tags = {
    environment = var.environment
  }
}
