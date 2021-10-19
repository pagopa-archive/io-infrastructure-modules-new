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

resource "azurerm_dns_a_record" "dns_a_record" {
  name                = var.nane
  zone_name           = var.zone_name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  records             = var.records
  target_resource_id  = var.target_resource_id

  tags = {
    environment = var.environment
  }
}
