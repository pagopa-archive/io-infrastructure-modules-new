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

resource "azurerm_storage_account" "storage_account" {
  name                      = local.resource_name
  resource_group_name       = var.resource_group_name
  location                  = var.region
  account_kind              = var.account_kind
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
  access_tier               = var.access_tier
  enable_https_traffic_only = true

  static_website {
    index_document     = var.index_document
    error_404_document = var.error_404_document
  }

  tags = {
    environment = var.environment
  }
}

# Enable advanced threat protection
resource "azurerm_advanced_threat_protection" "advanced_threat_protection" {
  target_resource_id = azurerm_storage_account.storage_account.id
  enabled            = true
}

module "storage_account_versioning" {
  depends_on           = [azurerm_storage_account.storage_account]
  source               = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_storage_account_versioning?ref=update-azurerm-version-2.78.0"
  name                 = format("%s-versioning", local.resource_name)
  resource_group_name  = var.resource_group_name
  storage_account_name = local.resource_name
  enable               = var.enable_versioning
}

module "lock" {
  count             = var.lock != null ? 1 : 0
  source            = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_management_lock?ref=update-azurerm-version-2.78.0"
  global_prefix     = var.global_prefix
  environment_short = var.environment_short
  name              = var.lock.name
  scope             = azurerm_storage_account.storage_account.id
  lock_level        = var.lock.lock_level
  notes             = var.lock.notes
}
