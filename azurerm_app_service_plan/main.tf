terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

# New infrastructure

resource "azurerm_app_service_plan" "app_service_plan" {
  count               = var.module_disabled ? 0 : 1
  name                = local.resource_name
  resource_group_name = var.resource_group_name
  location            = var.region

  kind = var.kind

  sku {
    tier     = var.sku_tier
    size     = var.sku_size
    capacity = var.sku_capacity
  }

  maximum_elastic_worker_count = var.maximum_elastic_worker_count
  reserved                     = var.reserved

  tags = {
    environment = var.environment
  }
}
