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

variable "application_insights_id" {
  type = string
}

variable "kind" {
  type        = string
  description = "The kind of web test that this web test watches. Choices are ping and multistep"
  default     = "ping"

  validation {
    condition = (
      var.kind == "ping" ||
      var.kind == "multistep"
    )
    error_message = "Lock level can be ping or multistep."
  }
}

variable "frequency" {
  type        = number
  description = "Interval in seconds between test runs for this WebTest Default is 300."
  default     = 300
}

variable "timeout" {
  type        = number
  description = "Seconds until this WebTest will timeout and fail. Default is 10."
  default     = 10
}

variable "enabled" {
  type        = bool
  description = "Is the test actively being monitored."
}

variable "retry_enabled" {
  type        = bool
  description = "Allow for retries should this WebTest fail."
  default     = true
}

variable "geo_locations" {
  type        = list(string)
  description = "A list of where to physically run the tests from to give global coverage for accessibility of your application."
  # https://docs.microsoft.com/en-us/azure/azure-monitor/app/monitor-web-app-availability#azure full list
  # France South (Formerly France Central), France Central, North Europe, West Europe, UK South
  default     = ["emea-ch-zrh-edge",
                "emea-fr-pra-edge",
                "emea-gb-db3-azr",
                "emea-nl-ams-azr",
                "emea-ru-msa-edge"]
}

variable "configuration" {
  type        = string
  description = "An XML configuration specification for a WebTest."
  default     = "ping.xml"
}

variable "url" {
  type        = string
  description = "An XML configuration specification for a WebTest."
}

locals {
  resource_name = "${var.global_prefix}-${var.environment_short}-wt-${var.name}"
}
