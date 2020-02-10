# General Variables
variable "global_prefix" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "name" {
  type = string
}

// Resource Group 
variable "resource_group_name" {
  type = string
}

// CosmosDB specific variables
variable "enable_automatic_failover" {
  type    = bool
  default = true 
}

variable "offer_type" {
  type        = string
  description = "The CosmosDB account offer type. At the moment can only be set to Standard"
  default     = "Standard"
}

variable "kind" {
  type        = string
  description = "Specifies the Kind of CosmosDB to create - possible values are GlobalDocumentDB and MongoDB."
}

variable "is_virtual_network_filter_enabled" {
  type        = bool
  description = "Enables virtual network filtering for this Cosmos DB account."
  default     = true
}

variable "virtual_network_rule" {
  type        = list(string)
  description = "The subnets id that are allowed to access this CosmosDB account."
  default     = []
}

variable "consistency_policy" {
  type = list(object({
    consistency_level       = string
    max_interval_in_seconds = number
    max_staleness_prefix    = number
  }))
  default = [
    {
      consistency_level = "BoundedStaleness"
      max_interval_in_seconds = 5
      max_staleness_prefix    = 100
    }
  ]
}

variable "geo_location" {
  type = list(object({
    prefix            = string
    location          = string
    failover_priority = number
  }))
}

locals {
  resource_name = "${var.global_prefix}-${var.environment}-cosmosac-${var.name}"
}
