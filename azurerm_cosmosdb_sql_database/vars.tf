variable "global_prefix" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "name" {
  type        = string
  description = "The name of the Cosmos DB SQL Database"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the Cosmos DB SQL Database is created."
}

variable "account_name" {
  type        = string
  description = "The name of the Cosmos DB SQL Database to create the table within."
}

variable "throughput" {
  type        = number
  description = "The throughput of SQL database (RU/s)."
  default     = null
}
