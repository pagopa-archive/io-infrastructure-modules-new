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
  type        = string
  description = "The name of the virtual network peering"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to start the virtual network peering"
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the virtual network from which the peering starts"
}

variable "key_vault_id" {
  type        = string
  description = "The key vault id where the remote virtual network id is stored as a secret."
}


variable "remote_virtual_network_secret_name" {
  type        = string
  description = "The secret name where the remote virtual network id is stored."
}

variable "allow_virtual_network_access" {
  type        = bool
  description = "Controls if the VMs in the remote virtual network can access VMs in the local virtual network."
  default     = true
}

variable "allow_forwarded_traffic" {
  type        = bool
  description = "Controls if forwarded traffic from VMs in the remote virtual network is allowed."
  default     = false
}

variable "allow_gateway_transit" {
  type        = bool
  description = "Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network."
  default     = false
}

variable "use_remote_gateways" {
  type        = bool
  description = "Controls if remote gateways can be used on the local virtual network"
  default     = false
}
