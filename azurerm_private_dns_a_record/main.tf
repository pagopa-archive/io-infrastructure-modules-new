provider "azurerm" {
  version = "=2.4.0"
  features {}
}

terraform {
  backend "azurerm" {}
}

resource "azurerm_private_dns_a_record" "private_dns_a_record" {

  name                = var.name
  zone_name           = var.zone_name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  records             = var.records
}