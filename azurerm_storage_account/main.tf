terraform {
  required_version = ">= 0.14.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.84.0"
    }
  }
  backend "azurerm" {}
}

resource "azurerm_storage_account" "storage_account" {
  name                      = local.resource_name
  resource_group_name       = var.resource_group_name
  location                  = var.region
  account_kind              = var.account_kind
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
  access_tier               = var.access_tier
  enable_https_traffic_only = true

  dynamic "blob_properties" {
    for_each = var.blob_properties_delete_retention_policy_days == null ? [] : ["dummy"]
    content {
      delete_retention_policy {
        days = var.blob_properties_delete_retention_policy_days
      }
    }
  }

  dynamic "network_rules" {
    for_each = var.network_rules == null ? [] : [var.network_rules]

    content {
      default_action             = length(network_rules.value.ip_rules) == 0 && length(network_rules.value.virtual_network_subnet_ids) == 0 ? network_rules.value.default_action : "Deny"
      bypass                     = network_rules.value.bypass
      ip_rules                   = network_rules.value.ip_rules
      virtual_network_subnet_ids = network_rules.value.virtual_network_subnet_ids
    }
  }

  tags = {
    environment = var.environment
  }
}

# Enable advanced threat protection
resource "azurerm_advanced_threat_protection" "advanced_threat_protection" {
  target_resource_id = azurerm_storage_account.storage_account.id
  enabled            = var.advanced_threat_protection_enable
}

module "storage_account_versioning" {
  depends_on           = [azurerm_storage_account.storage_account]
  source               = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_storage_account_versioning?ref=v4.0.0"
  name                 = format("%s-versioning", local.resource_name)
  resource_group_name  = var.resource_group_name
  storage_account_name = local.resource_name
  enable               = var.enable_versioning
}

module "lock" {
  count             = var.lock != null ? 1 : 0
  source            = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_management_lock?ref=v4.0.0"
  global_prefix     = var.global_prefix
  environment_short = var.environment_short
  name              = var.lock.name
  scope             = azurerm_storage_account.storage_account.id
  lock_level        = var.lock.lock_level
  notes             = var.lock.notes
}
