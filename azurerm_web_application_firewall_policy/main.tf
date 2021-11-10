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

resource "azurerm_web_application_firewall_policy" "web_application_firewall_policy" {
  name                = local.resource_name
  resource_group_name = var.resource_group_name
  location            = var.region


  dynamic "custom_rules" {
    for_each = var.custom_rules
    content {
      name      = custom_rules.value.name
      priority  = custom_rules.value.priority
      rule_type = custom_rules.value.rule_type
      action    = custom_rules.value.action

      dynamic "match_conditions" {
        for_each = custom_rules.value.match_conditions
        content {
          operator     = match_conditions.value.operator
          match_values = match_conditions.value.match_values

          dynamic "match_variables" {
            for_each = match_conditions.value.match_variables
            content {
              variable_name = match_variables.value.variable_name
              selector      = match_variables.value.selector
            }
          }
        }
      }
    }
  }

  policy_settings {
    enabled                     = var.policy_settings.enabled
    mode                        = var.policy_settings.mode
    file_upload_limit_in_mb     = var.policy_settings.file_upload_limit_in_mb
    request_body_check          = var.policy_settings.request_body_check
    max_request_body_size_in_kb = var.policy_settings.max_request_body_size_in_kb
  }

  managed_rules {

    dynamic "exclusion" {
      for_each = var.managed_rules.exclusion
      content {
        match_variable          = exclusion.value.match_variable
        selector                = exclusion.value.selector
        selector_match_operator = exclusion.value.selector_match_operator
      }
    }


    dynamic "managed_rule_set" {
      for_each = var.managed_rules.managed_rule_set
      content {
        type    = managed_rule_set.value.type
        version = managed_rule_set.value.version

        dynamic "rule_group_override" {
          for_each = managed_rule_set.value.rule_group_override
          content {
            rule_group_name = rule_group_override.value.rule_group_name
            disabled_rules  = rule_group_override.value.disabled_rules
          }
        }

      }
    }
  }

  tags = {
    environment = var.environment
  }

}
