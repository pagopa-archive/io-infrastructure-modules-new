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

variable "allowed_virtual_network_subnet_ids" {
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
      consistency_level       = "BoundedStaleness"
      max_interval_in_seconds = 5
      max_staleness_prefix    = 100
    }
  ]
}

variable "geo_locations" {
  type = list(object({
    prefix            = string
    location          = string
    failover_priority = number
  }))
  default = []
}

variable "enable_multiple_write_locations" {
  type        = bool
  description = "Enable multi-master support for this Cosmos DB account."
  default     = false 
}

variable "ip_range" {
  type        = string
  description = "The set of IP addresses or IP address ranges in CIDR form to be included as the allowed list of client IP's for a given database account."
  default     = ""
}

variable "capabilities" {
  type        = map(string)
  description = "The capabilities which should be enabled for this Cosmos DB account."
  default     = {}
}


locals {
  resource_name = "${var.global_prefix}-${var.environment}-cosmosac-${var.name}"
}
