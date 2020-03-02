provider "azurerm" {
  version = "=1.44.0"
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

module "storage_account" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_storage_account?ref=v0.0.24"

  global_prefix     = var.global_prefix
  environment       = var.environment
  environment_short = var.environment_short
  region            = var.region

  name                     = "app${var.name}"
  resource_group_name      = var.resource_group_name
  account_tier             = var.storage_account_info.account_tier
  account_replication_type = var.storage_account_info.account_replication_type
  access_tier              = var.storage_account_info.access_tier
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
  name                      = local.resource_name
  resource_group_name       = var.resource_group_name
  location                  = var.region
  version                   = var.runtime_version
  app_service_plan_id       = module.app_service_plan.id
  storage_connection_string = module.storage_account.primary_connection_string
  enabled                   = var.enabled

  site_config {
    min_tls_version = "1.2"
    ip_restriction  = var.ip_restriction
  }

  app_settings = merge(
    {
      APPINSIGHTS_INSTRUMENTATIONKEY = var.application_insights_instrumentation_key
      // TODO: Remove after release with https://github.com/terraform-providers/terraform-provider-azurerm/pull/5761
      WEBSITE_CONTENTAZUREFILECONNECTIONSTRING = module.storage_account.primary_connection_string
      WEBSITE_CONTENTSHARE                     = "${lower(local.resource_name)}-content"
    },
    var.app_settings,
    module.secrets_from_keyvault.secrets_with_value
  )

  https_only = var.https_only

  tags = {
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [
      site_config[0].virtual_network_name,
    ]
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "app_service_virtual_network_swift_connection" {
  app_service_id = azurerm_app_service.app_service.id
  subnet_id      = module.subnet.id
}

