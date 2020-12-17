terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

resource "azurerm_api_management_product" "api_management_product" {
  product_id            = var.product_id
  resource_group_name   = var.resource_group_name
  api_management_name   = var.api_management_name
  display_name          = var.display_name
  description           = var.description
  subscription_required = var.subscription_required
  approval_required     = var.approval_required
  published             = var.published
}

resource "azurerm_api_management_product_policy" "api_management_product_policy" {
  count = var.policy_xml == null ? 0 : 1

  product_id          = azurerm_api_management_product.api_management_product.product_id
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name
  xml_content         = var.policy_xml
}
