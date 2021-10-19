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


resource "azurerm_storage_management_policy" "storage_management_policy" {
  storage_account_id = var.storage_account_id

  dynamic "rule" {
    for_each = toset(var.rules)
    content {
      name    = rule.value.name
      enabled = rule.value.enabled

      dynamic "filters" {
        for_each = rule.value.filters == null ? [] : list(rule.value.filters)
        content {
          prefix_match = filters.value.prefix_match
          blob_types   = filters.value.blob_types
        }
      }

      actions {
        base_blob {
          tier_to_cool_after_days_since_modification_greater_than    = rule.value.actions.base_blob.tier_to_cool_after_days_since_modification_greater_than
          tier_to_archive_after_days_since_modification_greater_than = rule.value.actions.base_blob.tier_to_archive_after_days_since_modification_greater_than
          delete_after_days_since_modification_greater_than          = rule.value.actions.base_blob.delete_after_days_since_modification_greater_than
        }
        dynamic "snapshot" {
          for_each = rule.value.actions.snapshot == null ? [] : list(rule.value.actions.snapshot)
          content {
            delete_after_days_since_creation_greater_than = snapshot.value.delete_after_days_since_creation_greater_than
          }
        }
      }
    }
  }
}
