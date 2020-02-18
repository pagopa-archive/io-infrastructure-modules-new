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
    for_each = var.ag
    iterator = app

    content {
      name                           = app.value["hl_name"]
      frontend_ip_configuration_name = local.frontend_ip_configuration_name
      frontend_port_name             = local.frontend_port_name
      protocol                       = app.value["hl_protocol"]
      ssl_certificate_name           = app.value["hl_ssl_certificate_name"]
      require_sni                    = app.value["hl_require_sni"]
      host_name                      = app.value["hl_host_name"]
    }
  }

  dynamic "probe" {
    for_each = var.ag
    iterator = app

    content {
      name                = app.value["probe_name"]
      interval            = app.value["probe_interval"]
      protocol            = app.value["probe_protocol"]
      timeout             = app.value["probe_timeout"]
      unhealthy_threshold = app.value["probe_unhealthy_threshold"]
      path                = app.value["probe_path"]
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.ag
    iterator = app

    content {
      name                  = app.value["bhs_name"]
      cookie_based_affinity = app.value["bhs_cookie_based_affinity"]
      path                  = app.value["bhs_path"]
      protocol              = app.value["bhs_protocol"]
      port                  = app.value["bhs_port"]
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.ag
    iterator = app
    
    content {
      name                       = app.value["rrr_name"]
      rule_type                  = app.value["rrr_rule_type"]
      http_listener_name         = app.value["hl_name"]
      backend_address_pool_name  = app.value["bap_name"]
      backend_http_settings_name = app.value["bhs_name"]
    }
  }

  dynamic "backend_address_pool" {
    for_each = var.ag
    iterator = app

    content {
      name         = app.value["bap_name"]
      # fqdns        = app.value["bap_fqdns"]
      ip_addresses = app.value["bap_ip_addresses"]
    }   
  }
}


  // Required


#   probe {
#     host                = local.application_gateway_host_name
#     name                = local.probe_name
#     interval            = var.probe_interval
#     protocol            = var.probe_protocol
#     path                = "/status-0123456789abcdef"
#     timeout             = var.probe_timeout
#     unhealthy_threshold = var.probe_unhealthy_threshold
#   }

#   // Required
#   backend_http_settings {
#     name                  = local.backend_http_setting_name
#     cookie_based_affinity = "Disabled"
#     path                  = "/"
#     port                  = 80
#     protocol              = "Http"
#     request_timeout       = 180
#     probe_name            = local.probe_name
#   }

#   // Required
#   http_listener {
#     name                           = local.https_listener_name
#     frontend_ip_configuration_name = local.frontend_ip_configuration_name
#     frontend_port_name             = local.frontend_port_name
#     protocol                       = "Https"
#     ssl_certificate_name           = local.ssl_certificate_name
#     require_sni                    = true
#     host_name                      = local.application_gateway_host_name
#   }

#   // Required
#   request_routing_rule {
#     name                       = local.request_routing_rule_name
#     rule_type                  = "Basic"
#     http_listener_name         = local.https_listener_name
#     backend_address_pool_name  = local.backend_address_pool_name
#     backend_http_settings_name = local.backend_http_setting_name
#   }

# }

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
