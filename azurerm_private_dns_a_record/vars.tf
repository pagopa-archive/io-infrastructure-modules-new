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

variable "name" {
  type        = string
  description = "The name of the DNS A Record."
}

variable "zone_name" {
  type        = string
  description = "The name of private dns zone."
}

variable "ttl" {
  type        = number
  description = "The Time To Live (TTL) of the DNS record in seconds."
}

variable "records" {
  type        = list(string)
  description = "List of IPv4 Addresses."
}
