provider "azurerm" {
  version = "=2.11.0"
  features {}
}

terraform {
  backend "azurerm" {}
}

data "azurerm_key_vault_secret" "certificate_secret" {
  name         = var.custom_domains.certificate_name
  key_vault_id = var.custom_domains.keyvault_id
}

module "subnet" {
  module_disabled = var.avoid_old_subnet_delete == false && (var.subnet_id != null || var.virtual_network_info == null)

  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_subnet?ref=v2.0.25"

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

  sku {
    name     = var.sku.name
    tier     = var.sku.tier
    capacity = var.sku.capacity
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.custom_domains.identity_id]
  }

  ssl_policy {
    policy_type = "Custom"
    cipher_suites = [
      "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA",
      "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
      "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA",
      "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"
    ]
    min_protocol_version = "TLSv1_2"
  }

  gateway_ip_configuration {
    name      = local.gateway_ip_configuration_name
    subnet_id = var.subnet_id != null ? var.subnet_id : module.subnet.id
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = var.public_ip_info.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = var.frontend_port
  }

  ssl_certificate {
    name                = "sslcertificate"
    key_vault_secret_id = trimsuffix(data.azurerm_key_vault_secret.certificate_secret.id, "${data.azurerm_key_vault_secret.certificate_secret.version}")
  }

  dynamic "http_listener" {
    for_each = var.services
    iterator = service

    content {
      name                           = "httplistener-${service.value.name}"
      frontend_ip_configuration_name = local.frontend_ip_configuration_name
      frontend_port_name             = local.frontend_port_name
      protocol                       = service.value.http_listener.protocol
      host_name                      = service.value.http_listener.host_name
      ssl_certificate_name           = "sslcertificate"
      require_sni                    = true
    }
  }

  dynamic "backend_address_pool" {
    for_each = var.services
    iterator = service

    content {
      name         = "backendaddresspool-${service.value.name}"
      ip_addresses = service.value.backend_address_pool.ip_addresses
      fqdns        = service.value.backend_address_pool.fqdns
    }
  }

  dynamic "probe" {
    for_each = var.services
    iterator = service

    content {
      name                = "probe-${service.value.name}"
      host                = service.value.probe.host
      protocol            = service.value.probe.protocol
      path                = service.value.probe.path
      interval            = service.value.probe.interval
      timeout             = service.value.probe.timeout
      unhealthy_threshold = service.value.probe.unhealthy_threshold
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.services
    iterator = service

    content {
      name                  = "backendhttpsettings-${service.value.name}"
      protocol              = service.value.backend_http_settings.protocol
      port                  = service.value.backend_http_settings.port
      path                  = service.value.backend_http_settings.path
      cookie_based_affinity = service.value.backend_http_settings.cookie_based_affinity
      request_timeout       = service.value.backend_http_settings.request_timeout
      probe_name            = "probe-${service.value.name}"
      host_name             = service.value.backend_http_settings.host_name
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.services
    iterator = service

    content {
      name                       = "requestroutingrule-${service.value.name}"
      http_listener_name         = "httplistener-${service.value.name}"
      backend_address_pool_name  = "backendaddresspool-${service.value.name}"
      backend_http_settings_name = "backendhttpsettings-${service.value.name}"
      rule_type                  = "Basic"
    }
  }

  dynamic "waf_configuration" {
    for_each = var.waf_configuration == null ? [] : ["dummy"]

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

  dynamic "autoscale_configuration" {
    for_each = var.autoscale_configuration != null ? [var.autoscale_configuration] : []
    content {
      min_capacity = autoscale_configuration.value.min_capacity
      max_capacity = autoscale_configuration.value.max_capacity
    }
  }
}

resource "azurerm_dns_a_record" "dns_a_record" {
  for_each = { for service in var.services : service.name => service.a_record_name }

  name                = each.value
  zone_name           = var.custom_domains.zone_name
  resource_group_name = var.custom_domains.zone_resource_group_name
  ttl                 = 300
  records = [
    var.public_ip_info.ip
  ]
}
