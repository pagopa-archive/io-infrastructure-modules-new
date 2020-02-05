provider "azurerm" {
  version = "=1.42.0"
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

# New infrastructure

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = local.resource_name
  resource_group_name = var.resource_group_name
  location            = var.region

  kind                = lookup(var.app_service_plan_parameters,"kind",null)

  sku {
    tier     = lookup(var.app_service_plan_parameters,"sku_tier",null)
    size     = lookup(var.app_service_plan_parameters,"sku_size",null)
    capacity = lookup(var.app_service_plan_parameters,"sku_capacity",null)
  }

  maximum_elastic_worker_count = lookup(var.app_service_plan_parameters,"maximum_elastic_worker_count",null)
  reserved                     = lookup(var.app_service_plan_parameters,"reserved",false)

  tags = {
    environment = var.environment
  }
}


