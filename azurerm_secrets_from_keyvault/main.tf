terraform {
  required_version = ">= 0.14.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.84.0"
    }
  }
  backend "azurerm" {}
}

data "azurerm_key_vault_secret" "key_vault_secret" {
  for_each = var.secrets_map

  name         = each.value
  key_vault_id = var.key_vault_id
}
