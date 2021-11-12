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

resource "azurerm_storage_queue" "storage_queue" {
  name                 = var.name
  storage_account_name = var.storage_account_name
}
