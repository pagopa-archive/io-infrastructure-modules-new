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

data "azurerm_key_vault_secret" "notification_hub_gcm_key" {
  name         = "notification-hub-01-gc-m-key"
  key_vault_id = var.key_vault_id
}
data "azurerm_key_vault_secret" "notification_hub_bundle_id" {
  name         = "notification-hub-01-bundle-id"
  key_vault_id = var.key_vault_id
}
data "azurerm_key_vault_secret" "notification_hub_key_id" {
  name         = "notification-hub-01-key-id"
  key_vault_id = var.key_vault_id
}
data "azurerm_key_vault_secret" "notification_hub_team_id" {
  name         = "notification-hub-01-team-id"
  key_vault_id = var.key_vault_id
}
data "azurerm_key_vault_secret" "notification_hub_token_id" {
  name         = "notification-hub-01-token"
  key_vault_id = var.key_vault_id
}

# New infrastructure
resource "azurerm_notification_hub_namespace" "notification_hub_ns" {
  name                = local.ntfns_resource_name
  resource_group_name = var.resource_group_name
  location            = var.region
  namespace_type      = var.ntfns_namespace_type
  sku_name            = var.ntfns_sku_name
  enabled             = var.ntfns_enabled
}

resource "azurerm_notification_hub" "notification_hub" {
  name                = local.resource_name
  namespace_name      = azurerm_notification_hub_namespace.notification_hub_ns.name
  resource_group_name = var.resource_group_name
  location            = var.region

  apns_credential {
    application_mode = var.ntf_apns_credential_application_mode
    bundle_id        = data.azurerm_key_vault_secret.notification_hub_bundle_id.value
    key_id           = data.azurerm_key_vault_secret.notification_hub_key_id.value
    team_id          = data.azurerm_key_vault_secret.notification_hub_team_id.value
    token            = data.azurerm_key_vault_secret.notification_hub_token_id.value
  }

  gcm_credential {
    api_key = data.azurerm_key_vault_secret.notification_hub_gcm_key.value
  }
}
