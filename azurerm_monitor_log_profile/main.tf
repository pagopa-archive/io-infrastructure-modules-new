provider "azurerm" {
  version = "=2.0.0"
  features {}
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

resource "azurerm_monitor_log_profile" "monitor_log_profile" {
  name = var.name

  categories = var.categories

  locations = var.locations

  servicebus_rule_id = var.servicebus_rule_id
  storage_account_id = var.storage_account_id

  retention_policy {
    enabled = var.retention_policy.enabled
    days    = var.retention_policy.days
  }
}