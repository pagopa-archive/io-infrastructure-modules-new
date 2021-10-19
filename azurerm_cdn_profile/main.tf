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

resource "azurerm_cdn_profile" "cdn_profile" {
  name                = local.resource_name
  resource_group_name = var.resource_group_name
  location            = var.region
  sku                 = var.sku

  tags = {
    environment = var.environment
  }
}
