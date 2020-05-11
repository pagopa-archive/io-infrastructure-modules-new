provider "azurerm" {
  version = "=2.4.0"
  features {}
}

terraform {
  backend "azurerm" {}
}

resource "azurerm_private_dns_a_record" "private_dns_a_record" {
  count   = length(var.dns_records)
  name    = var.dns_records[count.index].name
  ttl     = var.dns_records[count.index].ttl
  records = var.dns_records[count.index].records

  zone_name           = var.zone_name
  resource_group_name = var.resource_group_name

}
