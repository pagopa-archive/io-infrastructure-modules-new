provider "azurerm" {
  version = "=2.0.0"
  features {}
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

resource "azurerm_monitor_diagnostic_setting" "monitor_diagnostic_setting" {
  name                       = "${var.name}-diagnostic-setting"
  target_resource_id         = var.target_resource_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  eventhub_name                  = var.eventhub_name
  eventhub_authorization_rule_id = var.eventhub_name == null ? null : var.eventhub_authorization_rule_id
  storage_account_id             = var.storage_account_id

  # Note: retention_policies are still required even if it is not useful 
  #       when we use the log analytics workspace.  
  dynamic "log" {
    iterator = l
    for_each = var.logs
    content {
      category = l.value.category
      enabled  = l.value.enabled
      retention_policy {
        enabled = l.value.retention_policy.enabled
        days    = l.value.retention_policy.days
      }
    }
  }

  dynamic "metric" {
    iterator = m
    for_each = var.metrics
    content {
      category = m.value.category
      enabled  = m.value.enabled
      retention_policy {
        enabled = m.value.retention_policy.enabled
        days    = m.value.retention_policy.days
      }
    }
  }
}
