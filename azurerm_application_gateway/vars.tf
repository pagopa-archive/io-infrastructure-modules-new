variable "global_tenant_id" {
  type = string
}

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

variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "sku" {
  type = object({
    name     = string
    tier     = string
    capacity = number
  })
}

variable "public_ip_info" {
  type = object({
    id = string
    ip = string
  })
}

variable "subnet_id" {
  type = string

  default = null
}

variable "virtual_network_info" {
  type = object({
    name                  = string
    resource_group_name   = string
    subnet_address_prefix = string
  })

  default = null
}

variable "avoid_old_subnet_delete" {
  type = bool

  default = false
}

variable "frontend_port" {
  type = number
}

variable "custom_domain" {
  type = object({
    zone_name                = string
    zone_resource_group_name = string
    identity_id              = string
    keyvault_id              = string
  })
}

variable "services" {
  type = list(object({
    name          = string
    a_record_name = string

    http_listener = object({
      protocol             = string
      host_name            = string
      ssl_certificate_name = string
    })

    backend_address_pool = object({
      ip_addresses = list(string)
      fqdns        = list(string)
    })

    probe = object({
      host                = string
      protocol            = string
      path                = string
      interval            = number
      timeout             = number
      unhealthy_threshold = number
    })

    backend_http_settings = object({
      protocol              = string
      port                  = number
      path                  = string
      cookie_based_affinity = string
      request_timeout       = number
      host_name             = string
    })

    # To associate a rule set whether it is required.
    # Set to null if not needed, one of the rule_set's name instead.
    rewrite_rule_set_name = string
  }))

}

variable "rewrite_rule_sets" {
  type = list(object({
    name = string
    rewrite_rules = list(object({
      name          = string
      rule_sequence = number
      condition = object({
        variable    = string
        pattern     = string
        ignore_case = bool
        negate      = bool
      })

      request_header_configurations = list(object({
        header_name  = string
        header_value = string
      }))

      response_header_configurations = list(object({
        header_name  = string
        header_value = string
      }))

    }))
  }))
  default = []
}


variable "firewall_policy_id" {
  type    = string
  default = null
}

variable "waf_configuration" {
  type = object({
    enabled          = bool
    firewall_mode    = string
    rule_set_type    = string
    rule_set_version = string
    disabled_rule_groups = list(object({
      rule_group_name = string
      rules           = list(string)
    }))
    request_body_check       = bool
    file_upload_limit_mb     = number
    max_request_body_size_kb = number
  })

  default = null
}

variable "autoscale_configuration" {
  type = object({
    min_capacity = number # in the range 0 to 100.
    max_capacity = number # in the range 2 to 125.
  })

  default = null
}

locals {
  resource_name                  = "${var.global_prefix}-${var.environment_short}-ag-${var.name}"
  gateway_ip_configuration_name  = "gatewayipconfiguration"
  frontend_ip_configuration_name = "frontendipconfiguration"
  frontend_port_name             = "frontendport"
}
