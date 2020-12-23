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

variable "index_document" {
  type = string
}

variable "error_404_document" {
  type    = string
  default = null
}

variable "enable_versioning" {
  type        = bool
  default     = false
  description = "Enable versioning"
}

variable "lock" {
  type = object({
    name       = string
    lock_level = string
    notes      = string
  })
  default = null
}

locals {
  resource_name = "${var.global_prefix}${var.environment_short}st${var.name}"
}
