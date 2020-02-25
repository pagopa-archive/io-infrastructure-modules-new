variable "name" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "container_access_type" {
  type    = string
  default = "private"
}
