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
  type    = bool
  default = false
}

variable "custom_domain" {
  type = object({
    zone_name                = string
    zone_resource_group_name = string
    identity_id              = string
    keyvault_id              = string
  })
}

variable "backend_address_pools" {
  type = list(object(
    {
      name         = string
      fqdns        = list(string)
      ip_addresses = list(string)
    }
  ))
}


variable "backend_http_settings" {
  type = list(object({
    cookie_based_affinity               = string
    affinity_cookie_name                = string
    name                                = string
    path                                = string
    port                                = number
    probe_name                          = string
    protocol                            = string
    request_timeout                     = number
    host_name                           = string
    pick_host_name_from_backend_address = bool
    trusted_root_certificate_names      = list(string)
    connection_draining = object({
      enabled           = bool
      drain_timeout_sec = number
    })
  }))
}

variable "probes" {
  type = list(object({
    name                                      = string
    host                                      = string
    protocol                                  = string
    path                                      = string
    interval                                  = number
    timeout                                   = number
    unhealthy_threshold                       = number
    pick_host_name_from_backend_http_settings = bool
  }))
  default = []
}
variable "frontend_ip_configurations" {

  type = list(object({
    name                          = string
    subnet_id                     = string
    private_ip_address            = string
    public_ip_address_id          = string
    public_ip_address             = string
    private_ip_address_allocation = string
    a_record_name                 = string
  }))
}

variable "gateway_ip_configurations" {
  type = list(object({
    name      = string
    subnet_id = string
  }))
}

variable "frontend_ports" {
  type = list(object({
    name = string
    port = number
  }))
  default = [{
    name = "frontendport"
    port = 443
  }]
}


variable "http_listeners" {
  type = list(object({
    name                           = string
    frontend_ip_configuration_name = string
    frontend_port_name             = string
    protocol                       = string
    host_name                      = string
    ssl_certificate_name           = string
    require_sni                    = bool
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

variable "request_routing_rules" {
  type = list(object({
    name                        = string
    rule_type                   = string
    http_listener_name          = string
    backend_address_pool_name   = string
    backend_http_settings_name  = string
    redirect_configuration_name = string
    rewrite_rule_set_name       = string
    url_path_map_name           = string
  }))

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
  resource_name = "${var.global_prefix}-${var.environment_short}-ag-${var.name}"
}
