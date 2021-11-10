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

# New infrastructure

resource "azurerm_app_service_plan" "app_service_plan" {
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
  per_site_scaling             = var.per_site_scaling

  tags = {
    environment = var.environment
  }
}
