terraform {
  required_version = ">= 0.14.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.87.0"
    }
  }
  backend "azurerm" {}
}

resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = local.resource_name
  location            = var.region
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  retention_in_days   = var.retention_in_days

  tags = {
    environment = var.environment
  }
}
