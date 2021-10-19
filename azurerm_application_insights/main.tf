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

resource "azurerm_application_insights" "application_insights" {
  name                = local.resource_name
  resource_group_name = var.resource_group_name
  location            = var.region
  retention_in_days   = var.retention_in_days
  application_type    = var.application_type

  tags = {
    environment = var.environment
  }
}
