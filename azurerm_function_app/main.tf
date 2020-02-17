provider "azurerm" {
  version = "=1.42.0"
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

module "storage_account" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_storage_account?ref=v0.0.8"

  global_prefix            = var.global_prefix
  environment              = var.environment
  region                   = var.region
  name                     = "func${var.name}"
  resource_group_name      = var.resource_group_name
  account_tier             = var.storage_account_info.account_tier
  account_replication_type = var.storage_account_info.account_replication_type
  access_tier              = var.storage_account_info.access_tier
}

module "app_service_plan" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_app_service_plan?ref=v0.0.8"

  global_prefix       = var.global_prefix
  environment         = var.environment
  region              = var.region
  name                = "func${var.name}"
  resource_group_name = var.resource_group_name
  kind                = var.app_service_plan_info.kind
  sku_tier            = var.app_service_plan_info.sku_tier
  sku_size            = var.app_service_plan_info.sku_size
}

module "subnet" {
  //source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_subnet?ref=v0.0.8"
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_subnet"

  global_prefix        = var.global_prefix
  environment          = var.environment
  region               = var.region
  name                 = "func${var.name}"
  resource_group_name  = var.virtual_network_info.resource_group_name
  virtual_network_name = var.virtual_network_info.name
  address_prefix       = var.virtual_network_info.subnet_address_prefix

  delegation = {
    name = "default"

    service_delegation = {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_function_app" "function_app" {
  name                      = local.resource_name
  resource_group_name       = var.resource_group_name
  location                  = var.region
  app_service_plan_id       = module.app_service_plan.id
  storage_connection_string = module.storage_account.primary_connection_string

  site_config {
    min_tls_version = "1.2"
  }

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY = var.application_insights_instrumentation_key
    // TODO: Remove after release with https://github.com/terraform-providers/terraform-provider-azurerm/pull/5761
    WEBSITE_CONTENTAZUREFILECONNECTIONSTRING = module.storage_account.primary_connection_string
    WEBSITE_CONTENTSHARE                     = "${lower(local.resource_name)}-content"
  }

  enable_builtin_logging = false

  tags = {
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [
      site_config[0].virtual_network_name,
    ]
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "app_service_virtual_network_swift_connection" {
  app_service_id = azurerm_function_app.function_app.id
  subnet_id      = module.subnet.id
}

resource "azurerm_template_deployment" "function_keys" {
  name = "javafunckeys"
  parameters = {
    functionApp = azurerm_function_app.function_app.name
  }
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"

  template_body = <<BODY
  {
      "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
      "contentVersion": "1.0.0.0",
      "parameters": {
          "functionApp": {"type": "string", "defaultValue": ""}
      },
      "variables": {
          "functionAppId": "[resourceId('Microsoft.Web/sites', parameters('functionApp'))]"
      },
      "resources": [
      ],
      "outputs": {
          "functionkey": {
              "type": "string",
              "value": "[listkeys(concat(variables('functionAppId'), '/host/default'), '2018-11-01').functionKeys.default]"                                                                                }
      }
  }
  BODY
}

// TODO: Remove
data "azurerm_key_vault_secret" "key_vault_secret" {
  for_each = var.secrets_map

  name         = each.value
  key_vault_id = var.key_vault_id
}