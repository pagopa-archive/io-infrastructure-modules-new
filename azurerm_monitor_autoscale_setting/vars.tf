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

variable "resource_group_name" {
  type = string
}

variable "name" {
  type        = string
  description = "The name of the AutoScale Setting."
}

variable "target_resource_id" {
  type        = string
  description = "The name of the Resource Group in the AutoScale Setting should be created."
}

variable "profiles" {
  type = list(object(
    {
      name = string
      capacity = object({
        # between 0 and 1000.
        default = number
        # between 0 and 1000.
        maximum = number
        # between 0 and 1000.
        minimum = number
      })
      rules = list(object({
        metric_trigger = object({
          metric_name        = string
          metric_resource_id = string
          operator           = string
          statistic          = string
          time_aggregation   = string
          time_grain         = string
          time_window        = string
          threshold          = string
        })
        scale_action = object({
          cooldown  = string
          direction = string
          type      = string
          value     = number
        })

      }))

      fixed_date = object({
        end      = string
        start    = string
        timezone = string

      })

      recurrence = object({
        timezone = string
        days     = list(string)
        hours    = list(string)
        minutes  = list(string)
      })
    })
  )
}

variable "notification" {
  type = object({
    email = object({
      send_to_subscription_administrator    = string
      send_to_subscription_co_administrator = string
      custom_emails                         = list(string)
    })
  })
  default = null
}
