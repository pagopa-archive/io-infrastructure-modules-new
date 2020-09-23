provider "null" {
  version = "=2.1.2"
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

resource "azurerm_dns_cname_record" "dns_cname_record" {
  name                = var.name
  zone_name           = var.dns_zone.name
  resource_group_name = var.dns_zone.resource_group_name
  ttl                 = 300
  record              = var.endpoint.hostname
}

resource "null_resource" "cdn_custom_domain" {
  # needs az cli > 2.0.81
  # see https://github.com/Azure/azure-cli/issues/12152

  provisioner "local-exec" {
    command = <<EOT
      az cdn custom-domain create \
        --resource-group ${var.resource_group_name} \
        --endpoint-name ${var.endpoint.name} \
        --profile-name ${var.profile_name} \
        --name ${replace(trim(azurerm_dns_cname_record.dns_cname_record.fqdn, "."), ".", "-")} \
        --hostname ${trim(azurerm_dns_cname_record.dns_cname_record.fqdn, ".")}
      az cdn custom-domain enable-https \
        --resource-group ${var.resource_group_name} \
        --endpoint-name ${var.endpoint.name} \
        --profile-name ${var.profile_name} \
        --name ${replace(trim(azurerm_dns_cname_record.dns_cname_record.fqdn, "."), ".", "-")}
    EOT
  }
}
