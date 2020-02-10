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

// Storage Account
variable "storage_account_name" {
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

// Storage Share
variable "storage_share_name" {
  type = string
}

# Container Group specific variables

variable "ip_address_type" {
  type        = string
  description = "The ip address type of the container"
  default     = "public"
}

variable "dns_name_label" {
  type = string
  description = "The DNS label/name for the container groups IP"
  default     = null
}

variable "os_type" {
  type        = string
  description = "The OS for the container group."
  default     = "Linux"
}

variable "container_object" {
  type = object({
    name     = string
    image    = string
    cpu      = string
    memory   = string
    port     = number
    protocol = string
    commands = list(string)
  })
}

variable "volumes" {
  type = list(object({
    name                 = string
    mount_path           = string
    read_only            = bool
  }))
 }

variable "workspace_id" {
  type = string
}

variable "workspace_key" {
  type = string
}      

variable "log_type" {
  type    = list(string)
 }

locals {
  resource_name = "${var.global_prefix}-${var.environment}-cg-${var.name}"
}
