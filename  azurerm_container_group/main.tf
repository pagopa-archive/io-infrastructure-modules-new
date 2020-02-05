provider "azurerm" {
  version = "=1.42.0"
}

terraform {
  backend "azurerm" {}
}

# Modules Section

module "rg" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_resource_group?ref=v0.0.1" 
  
  // Global parameters
  region        = var.region
  global_prefix = var.global_prefix
  environment   = var.environment

  // Module parameters
  name = var.resource_group_name    
}

module "storage_account" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_storage_account"

  // Global parameters
  region        = var.region
  global_prefix = var.global_prefix
  environment   = var.environment

  // Module parameters
  name                      = var.storage_account_name
  resource_group_name       = module.rg.resource_name
  account_kind              = var.account_kind
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
  access_tier               = var.access_tier
}

module "storage_share" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_storage_share"
  
  // Global parameters
  region        = var.region
  global_prefix = var.global_prefix
  environment   = var.environment

  // Module parameters
  name                 = var.storage_share_name
  storage_account_name = module.storage_account.resource_name

}
# New infrastructure

resource "azurerm_container_group" "container_group" {
  name                = local.resource_name
  location            = var.region
  resource_group_name = module.rg.resource_name
  ip_address_type     = var.ip_address_type
  dns_name_label      = var.dns_name_label
  os_type             = var.os_type

  dynamic "diagnostics" {
    for_each = var.diagnostics_enabled ? var.log_analytics_object : []

      content {
        log_analytics {
          workspace_id  = diagnostics.value["workspace_id"]
          workspace_key = diagnostics.value["workspace_key"]
          log_type      = diagnostics.value["log_type"]
        }
      }      
  }
  container {
    name     = var.container_object.name
    image    = var.container_object.image
    cpu      = var.container_object.cpu
    memory   = var.container_object.memory
    port     = var.container_object.port
    protocol = var.container_object.protocol
    command  = var.container_object.command

    dynamic "volume" {
      for_each = var.volume_enabled ? var.volume_object : []

      content {
        name                 = volume.value["name"]
        mount_path           = volume.value["mount_path"]
        read_only            = volume.value["read_only"]
        share_name           = module.storage_share.name
        storage_account_name = module.storage_account.resource_name
        storage_account_key  = module.storage_account.primary_access_key
      }
    }
  }

  tags = {
    environment = var.environment
  }
}
