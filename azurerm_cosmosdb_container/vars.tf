variable "global_prefix" {
  type = string
  description = "Prefix used to define the resource name."
}

variable "environment" {
  type          = string
  description   = "The name of the environment"
}

variable "name" {
  type        = string
  description = "The name of the Cosmos DB instance."
}

variable "resource_group_name" {
    type        = string
    description = "The name of the resource group in which the Cosmos DB SQL"  
}

variable "account_name" {
    type        = string
    description = "The name of the Cosmos DB Account to create the container within."
}

variable "database_name" {
    type        = string
    description = "The name of the Cosmos DB SQL Database to create the container within."
} 

variable "partition_key_path" {
    type        = string
    description = "Define a partition key."
    default     = null

} 
          
variable "throughput" {
    type        = number
    description = "The throughput of SQL container (RU/s). Must be set in increments of 100. The minimum value is 400."
    default     = null
}  

variable "default_ttl" {
    type        = number
    description = "The default time to live of SQL container. If missing, items are not expired automatically."
    default     = null

}              

variable "unique_key_paths" {
    type        = list(string)
    description = "A list of paths to use for this unique key."         
}

locals {
  resource_name         = "${var.global_prefix}-${var.environment}-cosmosdb-${var.name}"
}