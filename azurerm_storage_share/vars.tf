// Global parameter
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

// Specific resource

variable "name" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "quota" {
  type    = number
  default = 50
}

variable "module_depends_on" {
  type    = any
  default = null
}
