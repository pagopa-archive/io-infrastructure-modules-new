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

# this is a tempory implementation till an official one will be released:
# https://github.com/terraform-providers/terraform-provider-azurerm/issues/8268

resource "azurerm_template_deployment" "versioning" {
  name                = var.name
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"
  parameters = {
    "storageAccount" = var.storage_account_name
  }

  template_body = <<DEPLOY
        {
            "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
            "contentVersion": "1.0.0.0",
            "parameters": {
                "storageAccount": {
                    "type": "string",
                    "metadata": {
                        "description": "Storage Account Name"}
                }
            },
            "variables": {},
            "resources": [
                {
                    "type": "Microsoft.Storage/storageAccounts/blobServices",
                    "apiVersion": "2019-06-01",
                    "name": "[concat(parameters('storageAccount'), '/default')]",
                    "properties": {
                        "IsVersioningEnabled": ${var.enable}
                    }
                }
            ]
        }
    DEPLOY
}
