provider "azurerm" {
  version = "=1.44.0"
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

module "app_service_plan" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_app_service_plan?ref=v0.0.24"

  global_prefix     = var.global_prefix
  environment       = var.environment
  environment_short = var.environment_short
  region            = var.region

  name                = "app${var.name}"
  resource_group_name = var.resource_group_name
  kind                = var.app_service_plan_info.kind
  sku_tier            = var.app_service_plan_info.sku_tier
  sku_size            = var.app_service_plan_info.sku_size
}

module "subnet" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_subnet?ref=v0.0.24"

  global_prefix     = var.global_prefix
  environment       = var.environment
  environment_short = var.environment_short
  region            = var.region

  name                 = "app${var.name}"
  resource_group_name  = var.virtual_network_info.resource_group_name
  virtual_network_name = var.virtual_network_info.name
  address_prefix       = var.virtual_network_info.subnet_address_prefix

  delegation = {
    name = "default"

    service_delegation = {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

module "secrets_from_keyvault" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_secrets_from_keyvault?ref=v0.0.24"

  key_vault_id = var.app_settings_secrets.key_vault_id
  secrets_map  = var.app_settings_secrets.map
}

resource "azurerm_app_service" "app_service" {
  name                = local.resource_name
  resource_group_name = var.resource_group_name
  location            = var.region
  app_service_plan_id = module.app_service_plan.id
  enabled             = var.app_enabled
  https_only          = var.https_only
  client_cert_enabled = var.client_cert_enabled


  site_config {
    min_tls_version = "1.2"
    ip_restriction  = var.ip_restriction
  }

  app_settings = merge(
    {
      APPINSIGHTS_INSTRUMENTATIONKEY = var.application_insights_instrumentation_key
    },
    var.app_settings,
    module.secrets_from_keyvault.secrets_with_value
  )

  tags = {
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [
      site_config[0].virtual_network_name,
    ]
  }
}

data "azurerm_key_vault_secret" "certificate_value" {
  name         = var.certificate_name
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "certificate_password" {
  name         = var.certificate_password
  key_vault_id = var.key_vault_id
}

resource "azurerm_app_service_certificate" "certificate" {
  name                = local.app_service_certificate
  resource_group_name = var.resource_group_name
  location            = var.region
  pfx_blob            = data.azurerm_key_vault_secret.certificate_value.value
  password            = data.azurerm_key_vault_secret.certificate_password.value
}

resource "azurerm_app_service_custom_hostname_binding" "hostname" {
  hostname            = var.custom_hostname
  app_service_name    = azurerm_app_service.app_service.name
  resource_group_name = var.resource_group_name
  ssl_state           = var.ssl_state
  thumbprint          = azurerm_app_service_certificate.certificate.thumbprint
}

resource "azurerm_app_service_virtual_network_swift_connection" "app_service_virtual_network_swift_connection" {
  app_service_id = azurerm_app_service.app_service.id
  subnet_id      = module.subnet.id
}

resource "azurerm_dns_cname_record" "dns_cname_record" {
  count               = var.dns_cname_record == null ? 0 : 1
  name                = var.name
  zone_name           = var.dns_cname_record.zone_name
  resource_group_name = var.dns_cname_record.zone_resource_group_name
  ttl                 = 300
  record              = azurerm_app_service.app_service.default_site_hostname
}

# Azure Monitor
data "azurerm_monitor_diagnostic_categories" "app_service" {
  resource_id = azurerm_app_service.app_service.id
}

resource "azurerm_monitor_diagnostic_setting" "app_service" {
  name                       = local.diagnostic_name
  target_resource_id         = azurerm_app_service.app_service.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.app_service.logs
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
    for_each = data.azurerm_monitor_diagnostic_categories.app_service.metrics
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

