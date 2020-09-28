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

variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "private_dns_zone_name" {
  type        = string
  description = "The name of the Private DNS zone (without a terminating dot)."
}

variable "virtual_network_id" {
  type        = string
  description = "The Resource ID of the Virtual Network that should be linked to the DNS Zone."
}

variable "registration_enabled" {
  type        = bool
  description = "Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled?"
  default     = false
}
