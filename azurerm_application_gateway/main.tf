# Existing infrastructure
provider "azurerm" {
  version = "~>1.36"
}

terraform {
  backend "azurerm" {}
}


// Module 
module "static_ip" {

  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_public_ip?ref=v0.0.5"

  // Global parameters
  region        = var.region
  global_prefix = var.global_prefix
  environment   = var.environment

  // Module paremeters
  name                = local.ip_resource_name
  sku                 = var.ip_sku
  allocation_method   = var.ip_allocation_method
  resource_group_name = var.resource_group_name
}

module "subnet" {

  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_subnet?ref=v0.0.5"

  // Global parameters
  region        = var.region
  global_prefix = var.global_prefix
  environment   = var.environment
  
  // Module paremeters
  name                 = local.subnet_resource_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefix       = var.subnet_address_prefix
}

# Get certificate from keyvault
# data "azurerm_key_vault_secret" "certificate" {
#   name         = local.azurerm_key_vault_secret_certificate
#   key_vault_id = var.key_vault_id
# }

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
    min_capacity = var.autoscaling_configuration_min_capacity
    max_capacity = var.autoscaling_configuration_max_capacity
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
    port = var.frontend_port_port
  }

  # // Optional
  waf_configuration {
    enabled          = var.waf_configuration_enabled
    firewall_mode    = var.waf_configuration_firewall_mode
    rule_set_type    = var.waf_configuration_rule_set_type
    rule_set_version = var.waf_configuration_rule_set_version
  }

  # // Required
  # ssl_certificate {
  #   name     = local.ssl_certificate_name
  #   data     = data.azurerm_key_vault_secret.certificate.value
  #   password = ""
  # }

  // DYNANIC PART
  dynamic "http_listener" {
    for_each = [
      for k in var.ag: k["hl"]
    ]
    # iterator = app

    content {
      name                           = http_listener.value["name"]
      frontend_ip_configuration_name = local.frontend_ip_configuration_name
      frontend_port_name             = local.frontend_port_name
      protocol                       = http_listener.value["protocol"]
      ssl_certificate_name           = http_listener.value["ssl_certificate_name"]
      require_sni                    = http_listener.value["require_sni"]
      host_name                      = http_listener.value["host_name"]
    }
  }

  dynamic "probe" {
    for_each = [
      for k in var.ag: k["pb"]
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
      for k in var.ag: k["bhs"]
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
    for_each = [
      for k in var.ag: k["rrr"]
    ]
    
    content {
      name                       = request_routing_rule.value["name"]
      rule_type                  = request_routing_rule.value["rule_type"]
      http_listener_name         = "test"
      backend_address_pool_name  = request_routing_rule.value["bap_name"]
      backend_http_settings_name = request_routing_rule.value["bhs_name"]
    }
  }

  dynamic "backend_address_pool" {
    for_each = [
      for k in var.ag: k["bap"]
    ]

    content {
      name         = backend_address_pool.value["name"]
      # fqdns        = backend_address_pool.value["bap_fqdns"]
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
      category = lg.value["logs"]
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
      category = mt.value["metric"]
      enabled  = true

      retention_policy {
        enabled = true
        days    = var.diagnostic_logs_retention
      }
    }
  }
}
