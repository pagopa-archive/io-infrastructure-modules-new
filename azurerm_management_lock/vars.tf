# General variables

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

variable "scope" {
  type        = string
  description = "Specifies the scope at which the Management Lock should be created. Usually this is the resource id."
}


variable "lock_level" {
  type        = string
  description = "Specifies the scope at which the Management Lock should be created."
  default     = "CanNotDelete"

  validation {
    condition = (
      var.lock_level == "CanNotDelete" ||
      var.lock_level == "ReadOnly"
    )
    error_message = "Lock level can be CanNotDelete or ReadOnly."
  }
}

variable "notes" {
  type        = string
  description = "Specifies some notes about the lock. Maximum of 512 characters"
  default     = null

  validation {
    condition = (
      var.notes != null ? length(var.notes) <= 512 : true
    )
    error_message = "Notes Maximum of 512 characters."
  }

}

locals {
  resource_name = "${var.global_prefix}-${var.environment_short}-lock-${var.name}"
}
