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

resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = var.name
  resource_group_name = var.resource_group_name

  tags = {
    environment = var.environment
  }
}


module "azurerm_private_dns_a_record" {
  count  = length(var.dns_a_records)
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_private_dns_a_record?ref=v2.1.12"

  name                = var.dns_a_records[count.index].name
  zone_name           = azurerm_private_dns_zone.private_dns_zone.name
  resource_group_name = var.resource_group_name

  ttl     = var.dns_a_records[count.index].ttl
  records = var.dns_a_records[count.index].records

  environment = var.environment

}
