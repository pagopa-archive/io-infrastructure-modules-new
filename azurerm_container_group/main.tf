provider "azurerm" {
  version = "=1.42.0"
}

terraform {
  backend "azurerm" {}
}

# Modules Section

module "storage_account" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_storage_account?ref=v0.0.5"

  // Global parameters
  region        = var.region
  global_prefix = var.global_prefix
  environment   = var.environment

  // Module parameters
  name                      = var.storage_account_name
  resource_group_name       = var.resource_group_name
  account_kind              = var.storage_account_account_kind
  account_tier              = var.storage_account_account_tier
  account_replication_type  = var.storage_account_account_replication_type
  access_tier               = var.storage_account_access_tier
}

module "storage_share" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_storage_share?ref=v0.0.5"
  
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
  resource_group_name = var.resource_group_name
  ip_address_type     = var.ip_address_type
  dns_name_label      = var.dns_name_label
  os_type             = var.os_type

  dynamic "diagnostics" {
    for_each = var.log_types
    iterator = diag

    content {
      log_analytics {
        workspace_id  = var.workspace_id
        workspace_key = var.workspace_key
        log_type      = diag.value
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
    commands = var.container_object.commands

    dynamic "volume" {
      for_each = var.volumes
      iterator = vol

      content {
        name                 = vol.value["name"]
        mount_path           = vol.value["mount_path"]
        read_only            = vol.value["read_only"]
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
