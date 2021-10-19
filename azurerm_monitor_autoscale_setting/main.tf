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

data "azurerm_key_vault_secret" "key_vault_secret" {
  count        = var.notification.key_vault_id == null ? 0 : length(var.notification.email.custom_emails)
  name         = var.notification.email.custom_emails[count.index]
  key_vault_id = var.notification.key_vault_id
}

resource "azurerm_monitor_autoscale_setting" "monitor_autoscale_setting" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.region
  target_resource_id  = var.target_resource_id

  dynamic "profile" {
    for_each = { for p in var.profiles : p.name => p }
    content {
      name = profile.key
      capacity {
        default = profile.value.capacity.default
        minimum = profile.value.capacity.minimum
        maximum = profile.value.capacity.maximum
      }

      dynamic "rule" {
        for_each = { for r in profile.value.rules : r.name => r }
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

      dynamic "fixed_date" {
        for_each = profile.value.fixed_date != null ? [profile.value.fixed_date] : []
        content {
          timezone = fixed_date.value.timezone
          start    = fixed_date.value.start
          end      = fixed_date.value.end
        }
      }

      dynamic "recurrence" {
        for_each = profile.value.recurrence != null ? [profile.value.recurrence] : []
        content {
          timezone = recurrence.value.timezone
          days     = recurrence.value.days
          hours    = recurrence.value.hours
          minutes  = recurrence.value.minutes
        }
      }
    }
  }

  dynamic "notification" {
    for_each = var.notification != null ? [var.notification] : []
    content {
      email {
        send_to_subscription_administrator    = notification.value.email.send_to_subscription_administrator
        send_to_subscription_co_administrator = notification.value.email.send_to_subscription_co_administrator
        custom_emails                         = notification.value.key_vault_id != null ? split(", ", join(",", data.azurerm_key_vault_secret.key_vault_secret.*.value)) : notification.value.email.custom_emails
      }
    }
  }

  tags = {
    environment = var.environment
  }
}
