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

variable "virtual_network_name" {
  type = string
}

variable "address_prefix" {
  type        = string
  description = "(Deprecated in favour of address_prefixes) The address prefix to use for the subnet."
  default     = null
}

variable "address_prefixes" {
  type        = list(string)
  description = "The address prefixes to use for the subnet."
  default     = []
}

variable "delegation" {
  type = object({
    name = string
    service_delegation = object({
      name    = string
      actions = list(string)
    })
  })

  default = null
}

variable "service_endpoints" {
  type    = list(string)
  default = []
}

variable "enforce_private_link_endpoint_network_policies" {
  type        = bool
  description = "Enable or Disable network policies for the private link endpoint on the subnet."
  default     = false
}
