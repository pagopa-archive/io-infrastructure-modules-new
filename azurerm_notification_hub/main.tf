terraform {
  backend "azurerm" {}
}

data "azurerm_key_vault_secret" "notification_hub_gcm_key" {
  name         = var.gcm_credential_api_key
  key_vault_id = var.key_vault_id
}
data "azurerm_key_vault_secret" "notification_hub_bundle_id" {
  name         = var.apns_credential_bundle_id
  key_vault_id = var.key_vault_id
}
data "azurerm_key_vault_secret" "notification_hub_key_id" {
  name         = var.apns_credential_key_id
  key_vault_id = var.key_vault_id
}
data "azurerm_key_vault_secret" "notification_hub_team_id" {
  name         = var.apns_credential_team_id
  key_vault_id = var.key_vault_id
}
data "azurerm_key_vault_secret" "notification_hub_token_id" {
  name         = var.apns_credential_token
  key_vault_id = var.key_vault_id
}

resource "azurerm_notification_hub" "notification_hub" {
  name                = local.resource_name
  namespace_name      = var.namespace_name
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
