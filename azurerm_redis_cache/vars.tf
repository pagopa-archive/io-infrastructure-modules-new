variable "global_prefix" {
  type = string
  description = "Prefix used to define the resource name."
}

variable "environment" {
  type          = string
  description   = "The name of the environment"
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

variable "minimum_tls_version" {
    type        = string
    description = "The minimum TLS version."
    default     = "1.0"
}

variable "subnet_id" {
    type        = string 
    description = "The Subnet within which the Redis Cache should be deployed."
    default     = "" 
}

variable "private_static_ip_address" {
    type        = string
    description = "The Static IP Address to assign to the Redis Cache when hosted inside the Virtual Network"
    default     = ""
}

variable "family" {
    type        = string
    description = "The SKU family/pricing group to use"
}

variable sku_name {
    type        = string
    description = "The SKU of Redis to use"
}

variable "rdb_backup_enabled" {
    type        = bool
    description = "Is Backup Enabled?"
    default     = false
}

variable rdb_backup_frequency {
    type        = number
    description = "The Backup Frequency in Minutes."
    default = null
}

variable "rdb_backup_max_snapshot_count" {
    type        = number
    description = "The maximum number of snapshots to create as a backup."
    default     = null
}

variable "rdb_storage_connection_string" {
    type        = string 
    description = "The Connection String to the Storage Account"
    default     = ""
}

locals {
  resource_name = "${var.global_prefix}-${var.environment}-adgroup-${var.name}"
}