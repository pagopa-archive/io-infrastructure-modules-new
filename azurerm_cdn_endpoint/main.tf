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

  global_delivery_rule {
    cache_expiration_action {
      behavior = var.global_delivery_rule_cache_expiration_action.behavior
      duration = var.global_delivery_rule_cache_expiration_action.duration
    }
  }

  dynamic "delivery_rule" {
    for_each = { for d in var.delivery_rule_url_path_condition_cache_expiration_action : d.order => d }
    content {
      order = delivery_rule.key
      name  = delivery_rule.value.name
      url_path_condition {
        operator     = delivery_rule.value.operator
        match_values = delivery_rule.value.match_values
      }
      cache_expiration_action {
        behavior = delivery_rule.value.behavior
        duration = delivery_rule.value.duration
      }      
    }
  }

  tags = {
    environment = var.environment
  }
}
