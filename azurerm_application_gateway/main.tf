# Existing infrastructure
provider "azurerm" {
  version = "~>1.42"
}

terraform {
  backend "azurerm" {}
}

// Module 
module "static_ip" {

  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_public_ip?ref=v0.0.24"

  // Global parameters
  region              = var.region
  global_prefix       = var.global_prefix
  environment         = var.environment
  environment_short   = var.environment_short

  // Module paremeters
  name                = var.name
  sku                 = var.ip_sku
  allocation_method   = var.ip_allocation_method
  resource_group_name = var.resource_group_name
}

module "subnet" {

  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_subnet?ref=v0.0.24"

  // Global parameters
  region              = var.region
  global_prefix       = var.global_prefix
  environment         = var.environment
  environment_short   = var.environment_short
  
  // Module paremeters
  name                 = var.name
  resource_group_name  = var.subnet_resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefix       = var.subnet_address_prefix
}

data "azurerm_key_vault_secret" "certificate_value" {
  name         = var.certificate_name
  key_vault_id = var.key_vault_id 
}

data "azurerm_key_vault_secret" "certificate_password" {
  name         = var.certificate_password
  key_vault_id = var.key_vault_id 
}
# New infrastructure


# Application Gateway resource - SSL certificate
resource "azurerm_application_gateway" "ag" {
  name                = local.resource_name
  resource_group_name = var.resource_group_name
  location            = var.region

  sku {
    name = var.sku_name
    tier = var.sku_tier
  }

  autoscale_configuration {
    min_capacity = var.asc_min_capacity
    max_capacity = var.asc_max_capacity
  }

  // Required
  gateway_ip_configuration {
    name      = local.gateway_ip_configuration_name
    subnet_id = module.subnet.id
  }

  // Required
  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = module.static_ip.id
  }

  // Required
  frontend_port {
    name = local.frontend_port_name
    port = var.frontend_port
  }

  # // Optional
  waf_configuration {
    enabled          = var.wc_enabled
    firewall_mode    = var.wc_firewall_mode
    rule_set_type    = var.wc_rule_set_type
    rule_set_version = var.wc_rule_set_version
  }

  # // Required
  ssl_certificate {
    name     = local.ssl_certificate_name
    data     = data.azurerm_key_vault_secret.certificate_value.value
    password = data.azurerm_key_vault_secret.certificate_password.value
  }

  // DYNANIC PART
  dynamic "http_listener" {
    for_each = [
      for k in var.services: k["hl"]
    ]

    content {
      name                           = http_listener.value["name"]
      frontend_ip_configuration_name = local.frontend_ip_configuration_name
      frontend_port_name             = local.frontend_port_name
      protocol                       = http_listener.value["protocol"]
      ssl_certificate_name           = local.ssl_certificate_name
      require_sni                    = http_listener.value["require_sni"]
      host_name                      = http_listener.value["host_name"]
    }
  }

  dynamic "probe" {
    for_each = [
      for k in var.services: k["pb"]
    ]

    content {
      name                = probe.value["name"]
      interval            = probe.value["interval"]
      protocol            = probe.value["protocol"]
      timeout             = probe.value["timeout"]
      unhealthy_threshold = probe.value["unhealthy_threshold"]
      path                = probe.value["path"]
      host                = probe.value["host"]
    }
  }

  dynamic "backend_http_settings" {
    for_each = [
      for k in var.services: k["bhs"]
    ]

    content {
      name                  = backend_http_settings.value["name"]
      cookie_based_affinity = backend_http_settings.value["cookie_based_affinity"]
      path                  = backend_http_settings.value["path"]
      protocol              = backend_http_settings.value["protocol"]
      port                  = backend_http_settings.value["port"]
    }
  }

  dynamic "request_routing_rule" {
    for_each = local.request_routing_rule

    content {
      name                       = request_routing_rule.value["name"]
      rule_type                  = request_routing_rule.value["rule_type"]
      http_listener_name         = request_routing_rule.value["http_listener_name"]
      backend_address_pool_name  = request_routing_rule.value["backend_address_pool_name"]
      backend_http_settings_name = request_routing_rule.value["backend_http_settings_name"]
    }
  }

  dynamic "backend_address_pool" {
    for_each = [
      for k in var.services: k["bap"]
    ]

    content {
      name         = backend_address_pool.value["name"]
      ip_addresses = backend_address_pool.value["ip_addresses"]
    }   
  }
}

# # Get Diagnostic settings for AG
data "azurerm_monitor_diagnostic_categories" "ag" {
  resource_id = azurerm_application_gateway.ag.id
}

# Add diagnostic to AG - configure SSL
resource "azurerm_monitor_diagnostic_setting" "ag" {
  name                       = local.diagnostic_name
  target_resource_id         = azurerm_application_gateway.ag.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.ag.logs
    iterator = lg 

    content {
      category = lg.value
      enabled  = true

      retention_policy {
        enabled = true
        days    = var.diagnostic_logs_retention
      }
    }
  }

  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.ag.metrics
    iterator = mt 

    content {
      category = mt.value
      enabled  = true

      retention_policy {
        enabled = true
        days    = var.diagnostic_logs_retention
      }
    }
  }
}
