variable "global_prefix" {
  type = string
}

variable "environment" {
  type = string
}

variable "environment_short" {
  type = string
}

variable "region" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "policy_name" {
  type        = string
  description = "The name of the policy."
}

variable "custom_rules" {
  type = list(object({
    name      = string
    priority  = number
    rule_type = string
    action    = string

    match_conditions = list(object({
      match_variables = list(object({
        variable_name = string
        selector      = string
      }))
      match_values       = list(string)
      operator           = string
      negation_condition = string
      transforms         = list(string)
    }))
  }))
  default = []
}

variable "policy_settings" {
  type = object({
    enabled                     = string
    mode                        = string
    file_upload_limit_in_mb     = number
    request_body_check          = bool
    max_request_body_size_in_kb = number
  })
  default = null
}

variable "managed_rules" {
  type = object({
    exclusion = list(object({
      match_variable          = string
      selector                = string
      selector_match_operator = string
    }))
    managed_rule_set = list(object({
      type    = string
      version = string
      rule_group_override = list(object({
        rule_group_name = string
        disabled_rules  = list(string)
      }))
    }))
  })
}
