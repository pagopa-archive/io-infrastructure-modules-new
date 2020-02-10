provider "azurerm" {
  version = "=1.42.0"
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
  subnet_id                 = var.subnet_id
  private_static_ip_address = var.private_static_ip_address
  family                    = var.family
  sku_name                  = var.sku_name

  redis_configuration   {
    rdb_backup_frequency          = var.rdb_backup_frequency
    rdb_backup_max_snapshot_count = var.rdb_backup_max_snapshot_count
    rdb_backup_enabled            = var.rdb_backup_enabled
    rdb_storage_connection_string = var.rdb_storage_connection_string
  }

  tags = {
    environment = var.environment
  }
  # NOTE: There's a bug in the Redis API where the original storage connection string isn't being returned,
  # which is being tracked here [https://github.com/Azure/azure-rest-api-specs/issues/3037].
  # In the interim we use the ignore_changes attribute to ignore changes to this field.
#   lifecycle {
#     ignore_changes = ["redis_configuration.*.rdb_storage_connection_string"]
#   }
}