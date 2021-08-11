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

resource "azurerm_storage_account" "dns_forwarder" {
  name                      = "${var.global_prefix}${var.environment_short}st${replace(var.name,"-","")}"
  resource_group_name       = var.resource_group_name
  location                  = var.region
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  account_tier              = "Standard"

  account_replication_type = "LRS"

  tags = {
    environment = var.environment
  }
}

resource "azurerm_storage_share" "dns_forwarder" {
  name = "dns-forwarder-share"
  storage_account_name = azurerm_storage_account.dns_forwarder.name
  quota = 1
}

resource "azurerm_network_profile" "dns_forwarder" {
  name                = "${var.global_prefix}-${var.environment_short}-np-${var.name}"
  location            = var.region
  resource_group_name = var.resource_group_name

  container_network_interface {
    name = "container-nic"

    ip_configuration {
      name      = "ip-config"
      subnet_id = var.subnet_id
    }
  }
}

resource "azurerm_container_group" "coredns_forwarder" {
  name                = "${var.global_prefix}-${var.environment_short}-cg-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.region
  ip_address_type     = "Private"
  network_profile_id  = azurerm_network_profile.dns_forwarder.id
  os_type             = "Linux"

  container {
    name   = "dns-forwarder"
    image  = "coredns/coredns:1.8.4"
    cpu    = "0.5"
    memory = "0.5"

    commands = ["/coredns", "-conf", "/app/conf/Corefile"]

    ports {
      port     = 53
      protocol = "UDP"
    }

    ports {
      port     = 8080
      protocol = "TCP"
    }

    ports {
      port     = 8181
      protocol = "TCP"
    }

    environment_variables = {

    }

    volume {
      mount_path = "/app/conf"
      name       = "dns-forwarder-conf"
      read_only  = false
      share_name = azurerm_storage_share.dns_forwarder.name

      storage_account_key  = azurerm_storage_account.dns_forwarder.primary_access_key
      storage_account_name = azurerm_storage_account.dns_forwarder.name
    }

  }

  depends_on = [
    null_resource.upload_corefile
  ]

  tags = {
    environment = var.environment
  }
}

data "local_file" "corefile" {
  filename = "${path.module}/Corefile"
}

resource "null_resource" "upload_corefile" {

  triggers = {
    "changes-in-config" : md5(data.local_file.corefile.content)
  }

  provisioner "local-exec" {
    command = <<EOT
              az storage file upload \
                --account-name ${azurerm_storage_account.dns_forwarder.name} \
                --account-key ${azurerm_storage_account.dns_forwarder.primary_access_key} \
                --share-name ${azurerm_storage_share.dns_forwarder.name} \
                --source "${path.module}/Corefile"
          EOT
  }
}
