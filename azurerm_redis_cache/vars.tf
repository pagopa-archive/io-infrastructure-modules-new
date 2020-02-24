variable "global_prefix" {
  type = string
  description = "Prefix used to define the resource name."
}

variable "environment" {
  type          = string
  description   = "The name of the environment"
}

variable "environment_short" {
  type = string
}

variable "region" {
  type = string
  description = "The location of the resource group."
}

variable "name" {
  type        = string
  description = "The name of the Redis instance."
}

variable "resource_group_name" {
  type = string
}

variable "capacity" {
  type          = number
  description   = "The size of the Redis cache to deploy"
  default       = 1
}

variable "shard_count" {
    type        = number
    description = "The number of Shards to create on the Redis Cluster."
    default     = null
}

variable "enable_non_ssl_port" {
    type        = bool
    description = "Enable the non-SSL port (6379) - disabled by default."
    default     = false
}

variable "subnet_id" {
    type        = string 
    description = "The Subnet within which the Redis Cache should be deployed."
    default     = null 
}

variable "private_static_ip_address" {
    type        = string
    description = "The Static IP Address to assign to the Redis Cache when hosted inside the Virtual Network"
    default     = null
}

variable "family" {
    type        = string
    description = "The SKU family/pricing group to use"
}

variable sku_name {
    type        = string
    description = "The SKU of Redis to use"
}

# Redis configuration # 


# NOTE: enable_authentication can only be set to false if a subnet_id is specified; and only works 
# if there aren't existing instances within the subnet with enable_authentication set to true.
variable enable_authentication {
  type          = bool
  description   = "If set to false, the Redis instance will be accessible without authentication. Defaults to true."
  default       = true
}

variable backup_configuration {
  type = object({
    frequency = number
    max_snapshot_count = number
    storage_connection_string = string
  })
  default = null
}

locals {
  resource_name         = "${var.global_prefix}-${var.environment_short}-redis-${var.name}"
}