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
  description = "The name of the DNS CAA Record."
}

variable "zone_name" {
  type        = string
  description = "Specifies the DNS Zone where the resource exists."
}

variable "ttl" {
  type        = number
  description = "The Time To Live (TTL) of the DNS record in seconds."
  default     = 300
}

variable "records" {
  type        = list(string)
  default     = []
  description = "List of IPv4 Addresses."
}

variable "target_resource_id" {
  type        = string
  default     = null
  description = "The Azure resource id of the target object. "
}
