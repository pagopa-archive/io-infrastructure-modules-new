provider "azurerm" {
  version = "=2.11.0"
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
