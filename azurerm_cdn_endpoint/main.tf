provider "azurerm" {
  version = "=2.4.0"
  features {}
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

resource "azurerm_cdn_endpoint" "cdn_endpoint" {
  name                          = local.resource_name
  resource_group_name           = var.resource_group_name
  location                      = var.region
  profile_name                  = var.profile_name
  is_https_allowed              = var.is_https_allowed
  is_http_allowed               = var.is_http_allowed
  querystring_caching_behaviour = var.querystring_caching_behaviour
  origin_host_header            = var.origin_host_name

  origin {
    name      = "primary"
    host_name = var.origin_host_name
  }

  tags = {
    environment = var.environment
  }
}
