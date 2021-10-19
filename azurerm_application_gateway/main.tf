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

data "azurerm_key_vault_secret" "certificate_secret" {
  for_each     = { for s in var.http_listeners : s.ssl_certificate_name => s }
  name         = each.key
  key_vault_id = var.custom_domain.keyvault_id
}

module "subnet" {
  count = var.avoid_old_subnet_delete == false && (var.subnet_id != null || var.virtual_network_info == null) ? 0 : 1

  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_subnet?ref=update-azurerm-version-2.78.0"

  global_prefix     = var.global_prefix
  environment       = var.environment
  environment_short = var.environment_short
  region            = var.region

  name                 = "ag${var.name}"
  resource_group_name  = var.virtual_network_info != null ? var.virtual_network_info.resource_group_name : "none"
  virtual_network_name = var.virtual_network_info != null ? var.virtual_network_info.name : "none"
  address_prefix       = var.virtual_network_info != null ? var.virtual_network_info.subnet_address_prefix : "none"

  service_endpoints = [
    "Microsoft.Web"
  ]
}

resource "azurerm_application_gateway" "application_gateway" {
  name                = local.resource_name
  resource_group_name = var.resource_group_name
  location            = var.region


  dynamic "backend_address_pool" {
    for_each = var.backend_address_pools
    iterator = pool
    content {
      name         = pool.value.name
      fqdns        = pool.value.fqdns
      ip_addresses = pool.value.ip_addresses
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings
    iterator = setting

    content {
      cookie_based_affinity               = setting.value.cookie_based_affinity
      affinity_cookie_name                = setting.value.affinity_cookie_name
      name                                = setting.value.name
      path                                = setting.value.path
      port                                = setting.value.port
      probe_name                          = setting.value.probe_name
      protocol                            = setting.value.protocol
      request_timeout                     = setting.value.request_timeout
      host_name                           = setting.value.host_name
      pick_host_name_from_backend_address = setting.value.pick_host_name_from_backend_address
      trusted_root_certificate_names      = setting.value.trusted_root_certificate_names

      dynamic "connection_draining" {
        for_each = setting.value.connection_draining != null ? [setting.value.connection_draining] : []

        content {
          enabled           = connection_draining.value.enabled
          drain_timeout_sec = connection_draining.value.drain_timeout_sec
        }
      }
    }
  }

  dynamic "probe" {
    for_each = var.probes
    iterator = probe

    content {
      name                                      = probe.value.name
      host                                      = probe.value.host
      protocol                                  = probe.value.protocol
      path                                      = probe.value.path
      interval                                  = probe.value.interval
      timeout                                   = probe.value.timeout
      unhealthy_threshold                       = probe.value.unhealthy_threshold
      pick_host_name_from_backend_http_settings = probe.value.pick_host_name_from_backend_http_settings
    }
  }

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configurations
    iterator = ip_config

    content {
      name                          = ip_config.value.name
      subnet_id                     = ip_config.value.subnet_id
      private_ip_address            = ip_config.value.private_ip_address
      public_ip_address_id          = ip_config.value.public_ip_address_id
      private_ip_address_allocation = ip_config.value.private_ip_address_allocation
    }
  }

  dynamic "frontend_port" {
    for_each = var.frontend_ports
    iterator = port

    content {
      name = port.value.name
      port = port.value.port
    }
  }

  dynamic "gateway_ip_configuration" {
    for_each = var.gateway_ip_configurations
    iterator = ip_config

    content {
      name      = ip_config.value.name
      subnet_id = ip_config.value.subnet_id
    }
  }

  dynamic "http_listener" {
    for_each = var.http_listeners
    iterator = listener

    content {
      name                           = listener.value.name
      frontend_ip_configuration_name = listener.value.frontend_ip_configuration_name
      frontend_port_name             = listener.value.frontend_port_name
      protocol                       = listener.value.protocol
      host_name                      = listener.value.host_name
      ssl_certificate_name           = listener.value.ssl_certificate_name
      require_sni                    = listener.value.require_sni
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.request_routing_rules
    iterator = rule

    content {
      name                       = rule.value.name
      http_listener_name         = rule.value.http_listener_name
      backend_address_pool_name  = rule.value.backend_address_pool_name
      backend_http_settings_name = rule.value.backend_http_settings_name
      rule_type                  = rule.value.rule_type
      rewrite_rule_set_name      = rule.value.rewrite_rule_set_name
    }
  }

  dynamic "rewrite_rule_set" {
    for_each = var.rewrite_rule_sets
    iterator = rule_set
    content {
      name = rule_set.value.name

      dynamic "rewrite_rule" {
        for_each = rule_set.value.rewrite_rules
        content {
          name          = rewrite_rule.value.name
          rule_sequence = rewrite_rule.value.rule_sequence

          dynamic "condition" {
            for_each = rewrite_rule.value.condition == null ? [] : ["dummy"]
            content {
              variable    = condition.value.variable
              pattern     = condition.value.pattern
              ignore_case = condition.value.ignore_case
              negate      = condition.value.negate
            }
          }

          dynamic "request_header_configuration" {
            for_each = rewrite_rule.value.request_header_configurations
            iterator = req_header
            content {
              header_name  = req_header.value.header_name
              header_value = req_header.value.header_value
            }
          }

          dynamic "response_header_configuration" {
            for_each = rewrite_rule.value.response_header_configurations
            iterator = res_header
            content {
              header_name  = res_header.value.header_name
              header_value = res_header.value.header_value
            }
          }
        }
      }

    }
  }


  sku {
    name     = var.sku.name
    tier     = var.sku.tier
    capacity = var.sku.capacity
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.custom_domain.identity_id]
  }

  dynamic "ssl_certificate" {
    for_each = { for s in var.http_listeners : s.ssl_certificate_name => s }
    iterator = cert
    content {
      name                = cert.key
      key_vault_secret_id = trimsuffix(data.azurerm_key_vault_secret.certificate_secret[cert.key].id, data.azurerm_key_vault_secret.certificate_secret[cert.key].version)
    }
  }

  ssl_policy {
    policy_type = "Custom"
    cipher_suites = [
      "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
      "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",
      "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA",
      "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA"
    ]
    min_protocol_version = "TLSv1_2"
  }

  dynamic "autoscale_configuration" {
    for_each = var.autoscale_configuration != null ? [var.autoscale_configuration] : []
    content {
      min_capacity = autoscale_configuration.value.min_capacity
      max_capacity = autoscale_configuration.value.max_capacity
    }
  }

  firewall_policy_id = var.firewall_policy_id

  dynamic "waf_configuration" {
    for_each = var.waf_configuration == null || var.firewall_policy_id != null ? [] : ["dummy"]

    content {
      enabled                  = var.waf_configuration.enabled
      firewall_mode            = var.waf_configuration.firewall_mode
      rule_set_type            = var.waf_configuration.rule_set_type
      rule_set_version         = var.waf_configuration.rule_set_version
      request_body_check       = var.waf_configuration.request_body_check
      file_upload_limit_mb     = var.waf_configuration.file_upload_limit_mb
      max_request_body_size_kb = var.waf_configuration.max_request_body_size_kb

      dynamic "disabled_rule_group" {
        for_each = var.waf_configuration.disabled_rule_groups
        iterator = disabled_rule_group

        content {
          rule_group_name = disabled_rule_group.value.rule_group_name
          rules           = disabled_rule_group.value.rules
        }
      }
    }
  }

}

resource "azurerm_dns_a_record" "dns_a_record" {
  for_each = { for ip_config in concat(var.frontend_ip_configurations, var.optional_dns_a_records) : ip_config.name => { a_record_name = ip_config.a_record_name, records = ip_config.public_ip_address } }

  name                = each.value.a_record_name
  zone_name           = var.custom_domain.zone_name
  resource_group_name = var.custom_domain.zone_resource_group_name
  ttl                 = 300
  records             = [each.value.records]
}
