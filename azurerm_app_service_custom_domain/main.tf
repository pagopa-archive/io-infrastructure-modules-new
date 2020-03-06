provider "azurerm" {
  version = "=1.44.0"
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

// Add a custom domain for the app_service
data "azurerm_key_vault_secret" "certificate_data" {
  name         = "certs-${var.custom_domain.certificate_name}-DATA"
  key_vault_id = var.custom_domain.key_vault_id
}

data "azurerm_key_vault_secret" "certificate_password" {
  name         = "certs-${var.custom_domain.certificate_name}-PASSWORD"
  key_vault_id = var.custom_domain.key_vault_id
}

resource "azurerm_app_service_certificate" "certificate" {
  name                = local.app_service_certificate
  resource_group_name = var.resource_group_name
  location            = var.region
  pfx_blob            = data.azurerm_key_vault_secret.certificate_data.value
  password            = data.azurerm_key_vault_secret.certificate_password.value
}

resource "azurerm_dns_cname_record" "dns_cname_record" {
  name                = var.custom_domain.name
  zone_name           = var.custom_domain.zone_name
  resource_group_name = var.custom_domain.zone_resource_group_name
  ttl                 = 300
  record              = var.default_site_hostname
}

resource "azurerm_app_service_custom_hostname_binding" "hostname" {
  hostname            = trim(azurerm_dns_cname_record.dns_cname_record.fqdn, ".")
  app_service_name    = var.app_service.name
  resource_group_name = var.resource_group_name
  ssl_state           = var.ssl_state
  thumbprint          = azurerm_app_service_certificate.certificate.thumbprint
}

