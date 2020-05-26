provider "azurerm" {
  version = "=2.11.0"
  features {}
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

resource "azurerm_monitor_autoscale_setting" "monitor_autoscale_setting" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.region
  target_resource_id  = var.target_resource_id

  dynamic "profile" {
    for_each = toset(var.profiles)
    content {
      name = profile.value.name
      capacity {
        default = profile.value.capacity.default
        minimum = profile.value.capacity.minimum
        maximum = profile.value.capacity.maximum
      }

      dynamic "rule" {
        for_each = profile.value.rule
        content {
          metric_trigger {
            metric_name        = rule.value.metric_trigger.metric_name
            metric_resource_id = rule.value.metric_trigger.metric_resource_id
            time_grain         = rule.value.metric_trigger.time_grain
            statistic          = rule.value.metric_trigger.statistic
            time_window        = rule.value.metric_trigger.time_window
            time_aggregation   = rule.value.metric_trigger.time_aggregation
            operator           = rule.value.metric_trigger.operator
            threshold          = rule.value.metric_trigger.threshold
          }
          scale_action {
            direction = rule.value.scale_action.direction
            type      = rule.value.scale_action.type
            value     = rule.value.scale_action.value
            cooldown  = rule.value.scale_action.cooldown
          }
        }
      }
    }
  }


  tags = {
    environment = var.environment
  }
}