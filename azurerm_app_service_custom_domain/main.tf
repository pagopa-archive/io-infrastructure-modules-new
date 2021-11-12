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

// Add a custom domain for the app_service
resource "azurerm_dns_cname_record" "dns_cname_record" {
  name                = var.custom_domain.name
  zone_name           = var.custom_domain.zone_name
  resource_group_name = var.custom_domain.zone_resource_group_name
  ttl                 = 300
  record              = var.default_site_hostname
}

resource "azurerm_app_service_custom_hostname_binding" "hostname_binding" {
  hostname            = trim(azurerm_dns_cname_record.dns_cname_record.fqdn, ".")
  app_service_name    = var.app_service_name
  resource_group_name = var.resource_group_name
  ssl_state           = var.ssl_state
  thumbprint          = var.custom_domain.certificate_thumbprint
}
