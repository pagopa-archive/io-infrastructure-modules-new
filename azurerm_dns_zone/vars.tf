# General variables

variable "global_prefix" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "dns_zone_name" {
  type        = string
  description = "The name of the DNS Zone. Must be a valid domain name."
}
