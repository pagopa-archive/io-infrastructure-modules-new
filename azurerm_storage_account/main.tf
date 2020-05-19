provider "azurerm" {
  version = "=2.9.0"
  features {}
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
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

  blob_properties {
    dynamic "delete_retention_policy" {
      for_each = var.blob_properties_delete_retention_policy_days == null ? [] : ["dummy"]

      content {
        days = var.blob_properties_delete_retention_policy_days
      }
    }
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
