terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

resource "azurerm_application_insights_web_test" "application_insights_web_test" {
  name                    = local.resource_name
  resource_group_name     = var.resource_group_name
  location                = var.region
  application_insights_id = var.application_insights_id

  kind          = var.kind
  frequency     = var.frequency
  timeout       = var.timeout
  enabled       = var.enabled
  retry_enabled = var.retry_enabled
  geo_locations = var.geo_locations
  configuration = templatefile(var.configuration, { name = local.resource_name,
    url         = var.url,
    timeout     = var.timeout,
    http_method = var.http_method,
  http_status_code = var.http_status_code, })

  tags = {
    environment = var.environment
    # https://github.com/terraform-providers/terraform-provider-azurerm/issues/7026
    # azurerm_application_insights_web_test creates hidden tag that always reflects a "change"
    # A reference to a resource type must be followed by at least one attribute access, specifying the resource name.
    # "hidden-link:${var.application_insights_id}" = Resource
  }

  # suggestion to avoid azurerm_application_insights_web_test hidden-link changes
  lifecycle {
    ignore_changes = [tags]
  }
}
