provider "azurerm" {
  version = "=1.44.0"
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

module "public_ip" {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_public_ip?ref=v0.0.22"

  global_prefix       = var.global_prefix
  environment         = var.environment
  environment_short   = var.environment_short
  region              = var.region
  name                = "vpngw"
  resource_group_name = var.resource_group_name
  allocation_method   = var.public_ip_allocation_method
  sku                 = var.public_ip_sku
}


resource "azurerm_virtual_network_gateway" "virtual_network_gateway" {
  name                = local.resource_name
  location            = var.region
  resource_group_name = var.resource_group_name

  type     = var.type
  vpn_type = var.vpn_type

  active_active                    = var.active_active
  enable_bgp                       = var.enable_bgp
  sku                              = var.sku
  default_local_network_gateway_id = var.default_local_network_gateway_id
  generation                       = var.generation

  #Note: the public ip address would be the same for all the ip_configuration occurences
  # and it is not the expected behaviour. If needed fix it! The simplest approach it might be
  # to use the resuorce ip_address with the attribute count in place of the module. 
  dynamic "ip_configuration" {
    for_each = var.ip_configurations
    content {
      name                          = ip_configuration.value.name
      public_ip_address_id          = module.public_ip.id
      private_ip_address_allocation = ip_configuration.value.private_ip_address_allocation
      subnet_id                     = var.subnet_id
    }
  }

  dynamic "vpn_client_configuration" {
    for_each = var.vpn_client_configurations
    content {
      address_space = vpn_client_configuration.value.address_space
      dynamic "root_certificate" {
        for_each = vpn_client_configuration.value["root_certificates"]
        content {
          name             = root_certificate.value["name"]
          public_cert_data = root_certificate.value["public_cert_data"]
        }
      }
      # todo
      #revoked_certificate {}
      dynamic "revoked_certificate" {
        for_each = vpn_client_configuration.value["revoked_certificates"]
        content {
          name       = revoked_certificate.value["name"]
          thumbprint = revoked_certificate.value["thumbprint"]
        }
      }
      radius_server_address = vpn_client_configuration.value.radius_server_address
      radius_server_secret  = vpn_client_configuration.value.radius_server_secret
      vpn_client_protocols  = []
    }
  }

  tags = {
    environment = var.environment
  }
}