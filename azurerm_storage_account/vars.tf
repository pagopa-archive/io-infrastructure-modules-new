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

variable "account_kind" {
  type    = string
  default = "StorageV2"
}

variable "account_tier" {
  type = string
}

variable "account_replication_type" {
  type = string
}

variable "access_tier" {
  type = string
}

variable "blob_properties_delete_retention_policy_days" {
  type        = number
  description = "Enable soft delete policy and specify the number of days that the blob should be retained"
  default     = null
}


# Note: If specifying network_rules, one of either ip_rules or virtual_network_subnet_ids must be specified
# and default_action must be set to Deny.

variable "network_rules" {
  type = object({
    default_action             = string # Valid option Deny Allow
    bypass                     = set(string)
    ip_rules                   = list(string)
    virtual_network_subnet_ids = list(string)
  })
  default = null
}

locals {
  resource_name = "${var.global_prefix}${var.environment_short}st${var.name}"
}
