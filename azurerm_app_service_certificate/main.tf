provider "azurerm" {
  version = "=2.18.0"
  features {}
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

data "azurerm_key_vault_secret" "certificate_secret" {
  name         = var.certificate_name
  key_vault_id = var.key_vault_id
}

resource "azurerm_app_service_certificate" "app_service_certificate" {
  name                = local.app_service_certificate
  resource_group_name = var.resource_group_name
  location            = var.region
  key_vault_secret_id = data.azurerm_key_vault_secret.certificate_secret.id
}
