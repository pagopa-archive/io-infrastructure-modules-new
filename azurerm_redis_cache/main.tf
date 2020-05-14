provider "azurerm" {
  version = "=2.9.0"
  features {}
}


terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

resource "azurerm_redis_cache" "redis_cache" {
  name                      = local.resource_name
  location                  = var.region
  resource_group_name       = var.resource_group_name
  capacity                  = var.capacity
  shard_count               = var.shard_count
  enable_non_ssl_port       = var.enable_non_ssl_port
  minimum_tls_version       = "1.2"
  subnet_id                 = var.subnet_id
  private_static_ip_address = var.private_static_ip_address
  family                    = var.family
  sku_name                  = var.sku_name


  redis_configuration {
    enable_authentication         = var.enable_authentication
    rdb_backup_enabled            = var.backup_configuration != null
    rdb_backup_frequency          = var.backup_configuration != null ? var.backup_configuration.frequency : null
    rdb_backup_max_snapshot_count = var.backup_configuration != null ? var.backup_configuration.max_snapshot_count : null
    rdb_storage_connection_string = var.backup_configuration != null ? var.backup_configuration.storage_connection_string : null
  }

  tags = {
    environment = var.environment
  }
  
  # NOTE: There's a bug in the Redis API where the original storage connection string isn't being returned,
  # which is being tracked here [https://github.com/Azure/azure-rest-api-specs/issues/3037].
  # In the interim we use the ignore_changes attribute to ignore changes to this field.
  lifecycle {
    ignore_changes = [redis_configuration[0].rdb_storage_connection_string]
  }
}