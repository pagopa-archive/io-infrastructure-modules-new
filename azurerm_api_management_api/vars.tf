variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "api_management_name" {
  type = string
}

variable "revision" {
  type = string
}

variable "display_name" {
  type = string
}

variable "description" {
  type = string
}

variable "host" {
  type = string
}

variable "path" {
  type = string
}

variable "protocols" {
  type = list(string)
}

variable "swagger_json_template" {
  type = string
}

variable "policy_xml" {
  type = string
}

variable "product_ids" {
  type = list(string)

  default = []
}
