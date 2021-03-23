terraform {
  required_version = ">= 0.14.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.46.1"
    }
  }
  backend "azurerm" {}
}

module "storage_account" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_storage_account?ref=v3.0.3"

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
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_storage_share?ref=v3.0.3"

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

    dynamic "liveness_probe" {
      for_each = var.container.liveness_probe == null ? [] : list(var.container.liveness_probe)

      content {
        exec                  = liveness_probe.value.exec
        initial_delay_seconds = liveness_probe.value.initial_delay_seconds
        period_seconds        = liveness_probe.value.period_seconds
        failure_threshold     = liveness_probe.value.failure_threshold
        success_threshold     = liveness_probe.value.success_threshold
        timeout_seconds       = liveness_probe.value.timeout_seconds

        dynamic "http_get" {
          for_each = liveness_probe.value.http_get == null ? [] : list(liveness_probe.value.http_get)
          content {
            path   = http_get.value.path
            port   = http_get.value.port
            scheme = http_get.value.scheme
          }
        }
      }
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
