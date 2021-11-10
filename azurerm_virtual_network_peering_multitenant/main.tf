terraform {
  required_version = ">= 0.14.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.84.0"
    }
  }
  backend "azurerm" {}
}

data "azurerm_key_vault_secret" "key_vault_secret" {
  name         = var.remote_virtual_network_secret_name
  key_vault_id = var.key_vault_id
}


resource "null_resource" "virtual_network_peering" {

  provisioner "local-exec" {
    when    = create
    command = <<EOT
az network vnet peering create \
--name ${var.name} \
--resource-group ${var.resource_group_name} \
--vnet-name ${var.virtual_network_name} \
--remote-vnet ${data.azurerm_key_vault_secret.key_vault_secret.value} %{if var.allow_forwarded_traffic}--allow-forwarded-traffic %{endif}%{if var.allow_gateway_transit}--allow-gateway-transit%{endif}%{if var.use_remote_gateways}--use-remote-gateways%{endif}%{if var.allow_virtual_network_access}--allow-vnet-access%{endif}
EOT
  }
}
