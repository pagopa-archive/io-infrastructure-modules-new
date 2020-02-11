variable "key_vault_id" {
    type        = string
    description = "Specifies the id of the Key Vault resource."
}


variable "tenant_id" {
    type        = string
    description = "The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault."
}

variable "object_id" {
    type        = string
    description = "The object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies."
}

variable "application_id" {
    type        = string
    description = "The object ID of an Application in Azure Active Directory."
    default     = null
}

variable "key_permissions" {
    type        = list(string)
    description = "List of key permissions."

}

variable "secret_permissions" {
    type        = list(string)
    description = "List of secret permissions."
}

variable "certificate_permissions" {
    type        = list(string)
    description = "List of certificate permissions."
    default     = null
}

variable "storage_permissions" {
    type        = list(string)
    description = "List of storage permissions."
    default     = null
}