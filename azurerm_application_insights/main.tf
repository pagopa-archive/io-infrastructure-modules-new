provider "azurerm" {
  version = "=2.11.0"
  features {}
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
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
