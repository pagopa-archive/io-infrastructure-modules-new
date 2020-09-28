terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

resource "azurerm_logic_app_workflow" "logic_app" {
  name                = local.resource_name
  resource_group_name = var.resource_group_name
  location            = var.region
}
