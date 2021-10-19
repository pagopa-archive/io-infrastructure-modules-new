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

variable "subnet_id" {
  type        = string
  description = "The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint."
}

variable "private_service_connection" {
  type = object({
    name                           = string
    private_connection_resource_id = string
    is_manual_connection           = bool
    subresource_names              = list(string)
    }
  )
}

variable "private_dns_zone_ids" {
  type        = list(string)
  default     = null
  description = "(Optional) Specifies the list of Private DNS Zones to write DNS records"
}
