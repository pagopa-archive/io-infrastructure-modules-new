provider "azurerm" {
  version = "=1.44.0"
}

terraform {
  backend "azurerm" {}
}

module "storage_account" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_storage_account?ref=v0.0.17"

  global_prefix     = var.global_prefix
  environment       = var.environment
  environment_short = var.environment_short
  region            = var.region

  name                     = "cg${replace(var.name, "/-|_/", "")}"
  resource_group_name      = var.resource_group_name
  account_tier             = var.storage_account_info.account_tier
  account_replication_type = var.storage_account_info.account_replication_type
  access_tier              = var.storage_account_info.access_tier
}

module "storage_share" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_storage_share?ref=v0.0.17"

  module_depends_on = module.storage_account.id

  // Global parameters
  region            = var.region
  global_prefix     = var.global_prefix
  environment       = var.environment
  environment_short = var.environment_short

  // Module parameters
  name                 = "containershare"
  storage_account_name = module.storage_account.resource_name
}

resource "azurerm_container_group" "container_group" {
  name                = local.resource_name
  location            = var.region
  resource_group_name = var.resource_group_name
  ip_address_type     = var.ip_address_type
  dns_name_label      = var.dns_name_label == null ? local.resource_name : var.dns_name_label
  os_type             = var.os_type

  container {
    name   = var.container.name
    image  = var.container.image
    cpu    = var.container.cpu
    memory = var.container.memory

    dynamic "ports" {
      for_each = var.container.ports

      content {
        port     = ports.value.port
        protocol = ports.value.protocol
      }
    }

    commands = var.container.commands

    volume {
      name                 = "containershare"
      mount_path           = var.storage_account_info.mount.path
      read_only            = var.storage_account_info.mount.read_only
      share_name           = module.storage_share.name
      storage_account_name = module.storage_account.resource_name
      storage_account_key  = module.storage_account.primary_access_key
    }
  }

  tags = {
    environment = var.environment
  }
}

resource "azurerm_dns_cname_record" "dns_cname_record" {
  count               = var.dns_cname_record == null ? 0 : 1
  name                = var.name
  zone_name           = var.dns_cname_record.zone_name
  resource_group_name = var.dns_cname_record.zone_resource_group_name
  ttl                 = 300
  record              = azurerm_container_group.container_group.fqdn
}
