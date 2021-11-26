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

resource "azurerm_dns_caa_record" "dns_caa_record" {
  name                = var.name
  zone_name           = var.zone_name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl

  dynamic "record" {
    for_each = var.records
    content {
      flags = record.value["flags"]
      tag   = record.value["tag"]
      value = record.value["value"]
    }
  }

  tags = {
    environment = var.environment
  }
}
