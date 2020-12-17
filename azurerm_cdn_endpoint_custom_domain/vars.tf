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

variable "ttl" {
  type        = string
  default     = 300
  description = "The Time To Live (TTL) of the DNS record in seconds."
}

variable "resource_group_name" {
  type = string
}

variable "dns_zone" {
  type = object({
    name                = string
    resource_group_name = string
  })
}

variable "profile_name" {
  type = string
}

variable "endpoint" {
  type = object({
    name     = string
    hostname = string
  })
}
