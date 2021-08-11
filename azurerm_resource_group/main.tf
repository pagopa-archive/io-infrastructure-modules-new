terraform {
  required_version = "= 0.12.26"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.18.0"
    }
  }
  backend "azurerm" {}
}

resource "azurerm_resource_group" "resource_group" {
  name     = local.resource_name
  location = var.region

  tags = {
    environment = var.environment
  }
}
