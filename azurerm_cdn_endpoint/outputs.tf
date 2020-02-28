output "id" {
  value = azurerm_cdn_endpoint.cdn_endpoint.id
}

output "hostname" {
  value = "${local.resource_name}.azureedge.net"
}

output "resource_name" {
  value = local.resource_name
}
