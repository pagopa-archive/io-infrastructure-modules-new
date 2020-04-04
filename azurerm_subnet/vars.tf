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

variable "delegations" {
  type = map(object({
    service_delegation = object({
      name    = string
      actions = list(string)
    })
  }))

  default = {}
}

variable "service_endpoints" {
  type    = list(string)
  default = []
}
