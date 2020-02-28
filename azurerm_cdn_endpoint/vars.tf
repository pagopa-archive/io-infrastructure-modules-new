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

locals {
  resource_name = "${var.global_prefix}-${var.environment_short}-cdnendpoint-${var.name}"
}
