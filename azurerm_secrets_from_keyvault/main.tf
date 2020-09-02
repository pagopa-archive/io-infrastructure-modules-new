provider "azurerm" {
  version = "=2.18.0"
  features {}
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

data "azurerm_key_vault_secret" "key_vault_secret" {
  for_each = var.secrets_map

  name         = each.value
  key_vault_id = var.key_vault_id
}
