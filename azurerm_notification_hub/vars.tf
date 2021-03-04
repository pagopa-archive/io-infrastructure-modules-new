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

variable "namespace_name" {
  type    = string
  default = "The name of the Notification Hub Namespace in which to create this Notification Hub"
}

variable "resource_group_name" {
  type = string
}

# Notification Hub related variables
variable "key_vault_id" {
  type        = string
  description = "The azure key vault id."
}

variable "ntf_apns_credential_application_mode" {
  type        = string
  description = "The Application Mode which defines which server the APNS Messages should be sent to. Possible values are Production and Sandbox."
}

variable "gcm_credential_api_key" {
  type        = string
  description = "The secret with the API Key associated with the Google Cloud Messaging service."
}

variable "apns_credential_bundle_id" {
  type        = string
  description = "The secret with the Bundle ID of the iOS/macOS application to send push notifications"
}

variable "apns_credential_key_id" {
  type        = string
  description = "The secret with the Apple Push Notifications Service (APNS) Key."
}

variable "apns_credential_team_id" {
  type        = string
  description = "The secret with the ID of the team the Token."
}

variable "apns_credential_token" {
  type        = string
  description = "The secret with the Push Token associated with the Apple Developer Account."
}

locals {
  resource_name = "${var.global_prefix}-${var.environment_short}-ntf-${var.name}"
}
