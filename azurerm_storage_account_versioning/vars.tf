variable "name" {
  type        = string
  description = "Template name"
}

variable "resource_group_name" {
  type = string
}

variable "storage_account_name" {
  type        = string
  description = "Name of the storage account"
}

variable "enable" {
  type        = bool
  default     = false
  description = "Enable versioning"
}
