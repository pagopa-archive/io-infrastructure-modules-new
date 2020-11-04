terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

resource "azurerm_storage_account" "storage_account" {
  name                      = local.resource_name
  resource_group_name       = var.resource_group_name
  location                  = var.region
  account_kind              = var.account_kind
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
  access_tier               = var.access_tier
  enable_https_traffic_only = true

  static_website {
    index_document     = var.index_document
    error_404_document = var.error_404_document
  }

  tags = {
    environment = var.environment
  }
}

# Enable advanced threat protection
resource "azurerm_advanced_threat_protection" "advanced_threat_protection" {
  target_resource_id = azurerm_storage_account.storage_account.id
  enabled            = true
}

resource "azurerm_dns_cname_record" "dns_cname_record" {
  count               = var.dns_cname_record == null ? 0 : 1
  name                = var.name
  zone_name           = var.dns_cname_record.zone_name
  resource_group_name = var.dns_cname_record.zone_resource_group_name
  ttl                 = var.dns_cname_record.ttl
  record              = azurerm_storage_account.storage_account.primary_web_host
}
