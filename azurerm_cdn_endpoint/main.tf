provider "azurerm" {
  version = "=2.11.0"
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

  dynamic "global_delivery_rule" {
    iterator = l
    for_each = var.global_delivery_rule_cache_expiration_action
    content {
      cache_expiration_action {
        behavior = l.value.behavior
        duration = l.value.duration
      }
    }
  }

  dynamic "delivery_rule" {
    iterator = l
    for_each = var.delivery_rule_url_path_condition_cache_expiration_action
    content {
      name  = l.value.name
      order = l.value.order
      url_path_condition {
        operator     = l.value.operator
        match_values = l.value.match_values
      }
      cache_expiration_action {
        behavior = l.value.behavior
        duration = l.value.duration
      }      
    }
  }

  tags = {
    environment = var.environment
  }
}
