output "id" {
  value = azurerm_function_app.function_app.id
}

output "default_key" {
  value     = azurerm_template_deployment.function_keys.outputs.functionkey
  sensitive = true
}

output "subnet_id" {
  value = module.subnet.id
}

output "resource_name" {
  value = local.resource_name
}

// TODO: Remove
output "secrets_values" {
  value = {
    for secret_name in keys(var.secrets_map) :
    secret_name => data.azurerm_key_vault_secret.key_vault_secret[secret_name].value
  }
}
