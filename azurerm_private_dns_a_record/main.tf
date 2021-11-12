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

resource "azurerm_private_dns_a_record" "private_dns_a_record" {
  name    = var.name
  ttl     = var.ttl
  records = var.records

  zone_name           = var.zone_name
  resource_group_name = var.resource_group_name

  tags = {
    environment = var.environment
  }

}
