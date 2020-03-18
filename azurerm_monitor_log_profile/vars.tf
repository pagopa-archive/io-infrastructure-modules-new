variable "global_prefix" {
  type        = string
  description = "Prefix used to define the resource name."
}

variable "environment" {
  type        = string
  description = "The name of the environment"
}

variable "environment_short" {
  type = string
}

variable "region" {
  type        = string
  description = "The location of the resource group."
}

variable "name" {
  type        = string
  description = "The name of the Log Profile."
}

variable "resource_group_name" {
  type = string
}

variable "categories" {
  type        = list
  description = "List of categories of the logs."
}

variable "locations" {
  type        = list
  description = "List of regions for which Activity Log events are stored or streamed."
}

variable "storage_account_id" {
  type        = string
  description = "The resource ID of the storage account in which the Activity Log is stored. At least one of storage_account_id or servicebus_rule_id must be set."
  default     = null
}

variable "servicebus_rule_id" {
  type        = string
  description = "The service bus (or event hub) rule ID of the service bus (or event hub) namespace in which the Activity Log is streamed to. At least one of storage_account_id or servicebus_rule_id must be set."
}

variable "retention_policy" {
  type = object({
    enabled = string
    days    = number
  })
}
