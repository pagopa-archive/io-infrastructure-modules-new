terraform {
  required_version = ">= 0.14.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.78.0"
    }
  }
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
    for_each = var.global_delivery_rule == null ? [] : [var.global_delivery_rule]
    iterator = gdr
    content {

      dynamic "cache_expiration_action" {
        for_each = gdr.value.cache_expiration_action
        iterator = cea
        content {
          behavior = cea.value.behavior
          duration = cea.value.duration
        }
      }

      dynamic "modify_request_header_action" {
        for_each = gdr.value.modify_request_header_action
        iterator = mrha
        content {
          action = mrha.value.action
          name   = mrha.value.name
          value  = mrha.value.value
        }
      }

      dynamic "modify_response_header_action" {
        for_each = gdr.value.modify_response_header_action
        iterator = mrha
        content {
          action = mrha.value.action
          name   = mrha.value.name
          value  = mrha.value.value
        }
      }
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

  dynamic "delivery_rule" {
    for_each = { for d in var.delivery_rule_request_scheme_condition : d.order => d }
    content {
      name  = delivery_rule.value.name
      order = delivery_rule.value.order

      request_scheme_condition {
        operator     = delivery_rule.value.operator
        match_values = delivery_rule.value.match_values
      }

      url_redirect_action {
        redirect_type = delivery_rule.value.url_redirect_action.redirect_type
        protocol      = delivery_rule.value.url_redirect_action.protocol
        hostname      = delivery_rule.value.url_redirect_action.hostname
        path          = delivery_rule.value.url_redirect_action.path
        fragment      = delivery_rule.value.url_redirect_action.fragment
        query_string  = delivery_rule.value.url_redirect_action.query_string
      }

    }
  }

  tags = {
    environment = var.environment
  }
}
