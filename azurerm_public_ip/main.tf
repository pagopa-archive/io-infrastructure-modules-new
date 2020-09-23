terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

resource "azurerm_public_ip" "public_ip" {
  name                = local.resource_name
  resource_group_name = var.resource_group_name
  location            = var.region
  sku                 = var.sku
  allocation_method   = var.allocation_method

  tags = {
    environment = var.environment
  }
}
