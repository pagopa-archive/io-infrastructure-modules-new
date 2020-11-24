# General variables
variable "environment" {
  type = string
}

variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "dns_a_records" {
  type = list(object({
    name    = string
    ttl     = number
    records = list(string)
  }))
  default = []
}
