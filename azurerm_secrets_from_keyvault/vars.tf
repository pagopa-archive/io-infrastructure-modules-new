variable "global_prefix" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "key_vault_id" {
  type = string
}

variable "secrets_map" {
  type = map(string)

  default = {}
}
