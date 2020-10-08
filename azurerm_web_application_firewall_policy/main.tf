terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

resource "azurerm_web_application_firewall_policy" "web_application_firewall_policy" {
  name                = var.policy_name
  resource_group_name = var.resource_group_name
  location            = var.region

  dynamic "custom_rules" {
    for_each = var.custom_rules
    content {
      name      = lookup(custom_rules.value, "name", null)
      priority  = custom_rules.value.priority
      rule_type = custom_rules.value.rule_type

      dynamic "match_conditions" {
        for_each = custom_rules.value.match_conditions
        content {

          dynamic "match_variables" {
            for_each = match_conditions.value.match_variables
            content {
              variable_name = match_variables.value.variable_name
              selector      = lookup(match_variables.value, "selector", null)
            }
          }

          match_values       = match_conditions.value.match_values
          operator           = match_conditions.value.operator
          negation_condition = looup(match_conditions.value, "negation_condition", null)
          transforms         = looup(match_conditions.value, "transforms", null)
        }
      }

      action = custom_rules.value.action

    }
  }


  policy_settings {
    enabled                     = lookup(var.policy_settings, "enabled", "Enabled")
    mode                        = lookup(var.policy_settings, "mode", "Prevention")
    file_upload_limit_in_mb     = lookup(var.policy_settings, "file_upload_limit_in_mb", 100)
    request_body_check          = lookup(var.policy_settings, "request_body_check", true)
    max_request_body_size_in_kb = lookup(var.policy_settings, "max_request_body_size_in_kb", 128)
  }

  managed_rules {

    dynamic "exclusion" {
      for_each = lookup(var.managed_rules, "exclusion", [])
      content {
        match_variable          = exclusion.value.match_variable
        selector                = lookup(exclusion.value, "selector", null)
        selector_match_operator = exclusion.value.selector_match_operator
      }
    }


    dynamic "managed_rule_set" {
      for_each = var.managed_rules.managed_rule_set
      content {
        type    = lookup(managed_rule_set.value, "type", null)
        version = managed_rule_set.value.version

        dynamic "rule_group_override" {
          for_each = lookup(managed_rule_set.value, "rule_group_override", [])
          content {
            rule_group_name = rule_group_override.value.rule_group_name
            disabled_rules  = lookup(rule_group_override.value, "disabled_rules", null)
          }
        }

      }
    }
  }

  tags = {
    environment = var.environment
  }

}
