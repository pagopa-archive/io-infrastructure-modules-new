# General variables

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

variable "zone_name" {
  type        = string
  description = "The name of private dns zone."
}

variable "dns_records" {
  type = list(object({
    name    = string
    ttl     = number
    records = list(string)
  }))
  default = []
}
