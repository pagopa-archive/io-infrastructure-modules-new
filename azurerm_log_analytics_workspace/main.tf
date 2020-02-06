provider "azurerm" {
  version = "~>1.42"
}

terraform {
  backend "azurerm" {}
}

resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = local.resource_name
  location            = var.region
  resource_group_name = var.resource_group_name
  sku                 = var.azurerm_log_analytics_workspace_sku
  retention_in_days   = var.azurerm_log_analytics_workspace_retention_in_days
}
