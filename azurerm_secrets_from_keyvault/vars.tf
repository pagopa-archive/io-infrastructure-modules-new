variable "key_vault_id" {
  type = string
}

variable "secrets_map" {
  type = map(string)

  default = {}
}
