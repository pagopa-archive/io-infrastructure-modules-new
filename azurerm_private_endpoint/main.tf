provider "azurerm" {
  version = "=2.4.0"
  features {}
}

terraform {
  backend "azurerm" {}
}

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = var.name
  location            = var.region
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = var.private_service_connection.name
    private_connection_resource_id = var.private_service_connection.private_connection_resource_id
    is_manual_connection           = var.private_service_connection.is_manual_connection
    subresource_names              = var.private_service_connection.subresource_names
  }

}


module "private_dns_zone" {
  module_disabled = var.private_dns_zone_name == null ? true : false
  #source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_private_dns_zone?ref=v2.0.22"
  source = "/home/uolter/src/pagoPa/io-infrastructure-modules-new/azurerm_private_dns_zone"

  global_prefix     = var.global_prefix
  environment       = var.environment
  environment_short = var.environment_short
  region            = var.region

  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name

}

module "private_dns_a_record" {
  source              = "/home/uolter/src/pagoPa/io-infrastructure-modules-new/azurerm_private_dns_a_record"
  #source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_private_dns_a_record?ref=v2.0.22"
  global_prefix       = var.global_prefix
  environment         = var.environment
  environment_short   = var.environment_short
  region              = var.region
  resource_group_name = var.resource_group_name
  zone_name           = var.private_dns_zone_name
  dns_records         = var.dns_records
}
