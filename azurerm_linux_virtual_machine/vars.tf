variable "global_prefix" {
  type        = string
  description = "Prefix used to define the resource name."
}

variable "environment" {
  type        = string
  description = "The name of the environment"
}

variable "environment_short" {
  type = string
}

variable "region" {
  type        = string
  description = "The location of the resource group."
}

variable "name" {
  type        = string
  description = "The name of the Redis instance."
}

variable "resource_group_name" {
  type = string
}

variable "admin_username" {
  type        = string
  description = "The username of the local administrator used for the Virtual Machine. Changing this forces a new resource to be created."
}

variable "computer_name" {
  type        = string
  description = "Specifies the Hostname which should be used for this Virtual Machine. If unspecified this defaults to the value for the name field"
  default     = null
}

variable "subnet_id" {
  type        = string
  description = "The ID of the Subnet where this Network Interface should be located in."
}

variable "size" {
  type        = string
  description = "The SKU which should be used for this Virtual Machine, such as Standard_F2."
}

variable "source_image_reference" {
  type = list(object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  }))
  default = []
}

variable "os_disk" {
  type = object({
    caching                   = string
    storage_account_type      = string
    disk_encryption_set_id    = string
    disk_size_gb              = string
    name                      = string
    write_accelerator_enabled = bool
  })
}

variable "admin_ssh_key" {
  type = list(object({
    public_key = string
    username   = string
  }))
  default = []
}

variable "security_rules" {
  type = list(object({
    name                         = string
    description                  = string
    priority                     = number
    direction                    = string
    access                       = string
    protocol                     = string
    source_port_ranges           = list(string)
    destination_port_ranges      = list(string)
    source_address_prefixes      = list(string)
    destination_address_prefixes = list(string)
  }))
}

variable "assign_public_ip" {
  type        = bool
  description = "Assign a public ip to the vm. Default true"
  default     = true
}

variable "allocation_method" {
  type    = string
  default = "Dynamic"
}

variable "plans" {
  type = list(object({
    name      = string
    product   = string
    publisher = string
    plan      = string
  }))
  default = []
}

variable "key_vault_id" {
  type    = string
  default = null
}

variable "dns_record" {
  type = object({
    name                     = string
    zone_name                = string
    zone_resource_group_name = string
    ttl                      = number
  })
  default = null
}

locals {
  resource_name               = "${var.global_prefix}-${var.environment_short}-vm-${var.name}"
  network_security_group_name = "${var.global_prefix}-${var.environment_short}-nsg-${var.name}"
  public_ip_name              = "${var.global_prefix}-${var.environment_short}-pip-${var.name}"
}
