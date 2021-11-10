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

resource "azurerm_resource_group" "resource_group" {
  name     = local.resource_name
  location = var.region

  tags = {
    environment = var.environment
  }
}
