terraform {
  required_version = ">= 0.14.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.78.0"
    }
  }
  backend "azurerm" {}
}

resource "azurerm_logic_app_workflow" "logic_app" {
  name                = local.resource_name
  resource_group_name = var.resource_group_name
  location            = var.region
  parameters = merge(
    var.parameters,
    module.secrets_from_keyvault.secrets_with_value
  )
}

module "secrets_from_keyvault" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_secrets_from_keyvault?ref=v3.0.3"

  key_vault_id = var.parameters_secrets.key_vault_id
  secrets_map  = var.parameters_secrets.map
}
