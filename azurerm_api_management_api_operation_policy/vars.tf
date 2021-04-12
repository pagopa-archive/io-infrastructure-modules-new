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
  type        = string
  description = "The name of the Resource Group in which the API Management Service exists. Changing this forces a new resource to be created."
}

variable "api_name" {
  type        = string
  description = "The ID of the API Management API Operation within the API Management Service"
}

variable "api_management_name" {
  type        = string
  description = "The name of the API Management Service."
}

variable "operation_id" {
  type        = string
  description = "The name of the operation Id"
}

variable "xml_content" {
  type        = string
  description = "The XML Content for this Policy."
}
