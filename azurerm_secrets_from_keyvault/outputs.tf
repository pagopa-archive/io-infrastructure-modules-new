output "secrets_with_value" {
  value = {
    for secret_name in keys(var.secrets_map) :
    secret_name => data.azurerm_key_vault_secret.key_vault_secret[secret_name].value
  }
}