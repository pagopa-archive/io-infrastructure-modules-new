provider "azuread" {
  version = "=0.7.0"
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

resource "azuread_group" "group" {
  name = local.resource_name
}
