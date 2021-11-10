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

resource "azurerm_network_ddos_protection_plan" "network_ddos_protection_plan" {
  name                = local.resource_name
  location            = var.region
  resource_group_name = var.resource_group_name

  tags = {
    environment = var.environment
  }
}
