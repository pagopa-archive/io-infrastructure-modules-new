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

variable "custom_domain" {
  type = object({
    name                     = string
    zone_name                = string
    zone_resource_group_name = string
    certificate_thumbprint   = string
  })
}

variable "ssl_state" {
  type    = string
  default = "SniEnabled"
}

variable "app_service_name" {
  type = string
}

variable "default_site_hostname" {
  type = string
}
