terraform {
  required_version = ">= 0.14.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.87.0"
    }
  }
  backend "azurerm" {}
}

data "template_file" "swagger_json" {
  template = var.swagger_json_template
  vars = {
    host = var.host
  }
}

resource "azurerm_api_management_api" "api_management_api" {
  name                  = var.name
  resource_group_name   = var.resource_group_name
  api_management_name   = var.api_management_name
  revision              = var.revision
  display_name          = var.display_name
  description           = var.description
  path                  = var.path
  protocols             = var.protocols
  subscription_required = var.subscription_required

  import {
    content_format = "swagger-json"
    content_value  = data.template_file.swagger_json.rendered
  }
}

resource "azurerm_api_management_api_policy" "api_management_api_policy" {
  api_name            = azurerm_api_management_api.api_management_api.name
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name

  xml_content = var.policy_xml
}

resource "azurerm_api_management_product_api" "api_management_product_api" {
  for_each = toset(var.product_ids)

  product_id          = each.value
  api_name            = azurerm_api_management_api.api_management_api.name
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name
}
