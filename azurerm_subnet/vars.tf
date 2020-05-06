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
  type = string
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

variable "module_disabled" {
  type = bool

  default = false
}

variable "enforce_private_link_endpoint_network_policies" {
  type        = bool
  description = "Enable or Disable network policies for the private link endpoint on the subnet."
  default     = false
}
