# Existing infrastructure
provider "azurerm" {
  version = "~>1.36"
}

terraform {
  backend "azurerm" {}
}

# Get certificate from keyvault

data "azurerm_key_vault_secret" "certificate" {
  name         = local.azurerm_key_vault_secret_certificate
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

# Get public IP info
data "azurerm_public_ip" "public_ip" {
  name                = local.azurerm_public_ip_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

# Get log_analytics_workspace_id
data "azurerm_log_analytics_workspace" "workspace" {
  name                = local.azurerm_log_analytics_workspace_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

# Get Diagnostic settings for AG
data "azurerm_monitor_diagnostic_categories" "ag" {
  resource_id = azurerm_application_gateway.ag_as_waf.id
}

data "azurerm_subnet" "subnet_ag_frontend" {
  name                 = local.azurerm_subnet_name
  virtual_network_name = local.azurerm_virtual_network_name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

# New infrastructure

# Application Gateway resource - SSL certificate
resource "azurerm_application_gateway" "ag" {
  name                = local.name
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

  gateway_ip_configuration {
    name      = local.gateway_ip_configuration_name
    subnet_id = data.azurerm_subnet.subnet_ag_frontend.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = var.frontend_port_port
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = data.azurerm_public_ip.public_ip.id
  }

  backend_address_pool {
    name         = local.backend_address_pool_name
    ip_addresses = [var.backend_address_pool_ip_addresses]
  }

  probe {
    host                = local.application_gateway_host_name
    name                = local.probe_name
    interval            = var.probe_interval
    protocol            = var.probe_protocol
    path                = "/status-0123456789abcdef"
    timeout             = var.probe_timeout
    unhealthy_threshold = var.probe_unhealthy_threshold
  }

  backend_http_settings {
    name                  = local.backend_http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 180
    probe_name            = local.probe_name
  }

  http_listener {
    name                           = local.https_listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Https"
    ssl_certificate_name           = local.ssl_certificate_name
    require_sni                    = true
    host_name                      = local.application_gateway_host_name
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.https_listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.backend_http_setting_name
  }

  waf_configuration {
    enabled          = var.waf_configuration_enabled
    firewall_mode    = var.waf_configuration_firewall_mode
    rule_set_type    = var.waf_configuration_rule_set_type
    rule_set_version = var.waf_configuration_rule_set_version
  }

  ssl_certificate {
    name     = local.ssl_certificate_name
    data     = data.azurerm_key_vault_secret.certificate.value
    password = ""
  }
}

# Add diagnostic to AG - configure SSL
resource "azurerm_monitor_diagnostic_setting" "ag" {
  name                       = local.diagnostic_name
  target_resource_id         = azurerm_application_gateway.ag_as_waf.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.workspace.id

  log {
    category = data.azurerm_monitor_diagnostic_categories.ag.logs[0]
    enabled  = true

    retention_policy {
      enabled = true
      days    = var.diagnostic_logs_retention
    }
  }

  log {
    category = data.azurerm_monitor_diagnostic_categories.ag.logs[1]
    enabled  = true

    retention_policy {
      enabled = true
      days    = var.diagnostic_logs_retention
    }
  }

  log {
    category = data.azurerm_monitor_diagnostic_categories.ag.logs[2]
    enabled  = true

    retention_policy {
      enabled = true
      days    = var.diagnostic_logs_retention
    }
  }

  metric {
    category = data.azurerm_monitor_diagnostic_categories.ag.metrics[0]

    retention_policy {
      enabled = true
      days    = var.diagnostic_metrics_retention
    }
  }
}
