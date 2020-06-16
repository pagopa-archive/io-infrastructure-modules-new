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

variable "profile_name" {
  type = string
}

variable "is_https_allowed" {
  type    = bool
  default = true
}

variable "is_http_allowed" {
  type    = bool
  default = false
}

variable "querystring_caching_behaviour" {
  type    = string
  default = "IgnoreQueryString"
}

// TODO: Allow multiple origin
variable "origin_host_name" {
  type = string
}

variable "global_delivery_rule_cache_expiration_action" {
  type = object({
    behavior = string
    duration = string
  })
}

variable "delivery_rule_url_path_condition_cache_expiration_action" {
  type = list(object({
    name         = string
    order        = number
    operator     = string
    match_values = list(string)
    behavior     = string
    duration     = string
  }))
  default = []
}

locals {
  resource_name = "${var.global_prefix}-${var.environment_short}-cdnendpoint-${var.name}"
}
