provider "azurerm" {
  version = "=2.4.0"
  features {}
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}


resource "azurerm_storage_management_policy" "storage_management_policy" {
  storage_account_id = var.storage_account_id

  dynamic "rule" {
    for_each = var.rules
    content {
      name    = rule.value.name
      enabled = rule.value.enabled

      filters {
        prefix_match = rule.value.filters.prefix_match
        blob_types   = rule.value.filters.blob_types
      }

      actions {
        base_blob {
          tier_to_cool_after_days_since_modification_greater_than    = rule.value.actions.base_blob.tier_to_cool_after_days_since_modification_greater_than
          tier_to_archive_after_days_since_modification_greater_than = rule.value.actions.base_blob.tier_to_archive_after_days_since_modification_greater_than
          delete_after_days_since_modification_greater_than          = rule.value.actions.base_blob.delete_after_days_since_modification_greater_than
        }
        snapshot {
          delete_after_days_since_creation_greater_than = rule.value.actions.snapshot.delete_after_days_since_creation_greater_than
        }
      }
    }
  }
}
