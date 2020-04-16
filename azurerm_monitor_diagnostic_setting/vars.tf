variable "target_resource_id" {
  type        = string
  description = "The id of the resource to monitor."
}

variable "name" {
  type        = string
  description = "Name of the dignostic setting"
}

variable "eventhub_name" {
  type        = string
  description = "Specifies the name of the Event Hub where Diagnostics Data should be sent."
  default     = null
}

variable "eventhub_resource_group_name" {
  type        = string
  description = "The name of the resource group where the event hub has been created."
  default     = null
}

variable "eventhub_namespace_name" {
  type        = string
  description = "The name of the eventhub namespace"
  default     = null
}

variable "eventhub_authorization_rule" {
  type        = string
  description = "Specifies the name of an Event Hub Namespace Authorization Rule used to send Diagnostics Data."
  default     = null
}

variable "storage_account_id" {
  type        = string
  description = "With this parameter you can specify a storage account which should be used to send the logs to. Parameter must be a valid Azure Resource ID."
  default     = null
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Specifies the ID of a Log Analytics Workspace where Diagnostics Data should be sent. Changing this forces a new resource to be created."
  default     = null
}

variable "logs" {
  type = list(object({
    category = string
    enabled  = bool
    retention_policy = object({
      enabled = bool
      days    = number
      }
    )
  }))
  default = []
}

variable "metrics" {
  type = list(object({
    category = string
    enabled  = bool
    retention_policy = object({
      enabled = bool
      days    = number
      }
    )
  }))
  default = []
}
