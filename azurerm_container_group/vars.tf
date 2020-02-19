# Global variables
variable "global_prefix" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

# Container Group variables
variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "ip_address_type" {
  type        = string
  description = "The ip address type of the container"
  default     = "public"
}

variable "dns_name_label" {
  type        = string
  description = "The DNS label/name for the container groups IP"
  default     = null
}

variable "os_type" {
  type        = string
  description = "The OS for the container group."
  default     = "Linux"
}

variable "container" {
  type = object({
    name   = string
    image  = string
    cpu    = string
    memory = string
    ports = list(object({
      port     = number
      protocol = string
    }))
    commands = list(string)
  })
}

variable "storage_account_info" {
  type = object({
    account_tier             = string
    account_replication_type = string
    access_tier              = string
    mount = object({
      path      = string
      read_only = bool
    })
  })

  default = {
    account_tier             = "Standard"
    account_replication_type = "LRS"
    access_tier              = "Cool"
    mount = {
      path      = "/containershare"
      read_only = true
    }
  }
}

locals {
  resource_name = "${var.global_prefix}-${var.environment}-cg-${var.name}"
}
