variable "target_resource_id" {
  type        = string
  description = "The id of the resource to monitor."
}

variable "name" {
  type        = string
  description = "Name of the dignostic setting"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Specifies the ID of a Log Analytics Workspace where Diagnostics Data should be sent. Changing this forces a new resource to be created."
}

variable "logs" {
  type  = list(object({
    category          = string
    enabled           = bool
    retention_policy = object({
      enabled  = bool
      days     = number
    }
    )
  }))
  default = []
}

variable "metrics" {
  type  = list(object({
    category          = string
    enabled           = bool
    retention_policy = object({
      enabled  = bool
      days     = number
    }
    )
  }))
  default = []
}
