variable "name_prefix" {
  type        = string
  description = "Prefix used to build resource names. Combined with a random suffix for the globally-unique Key Vault name."
  default     = "iackv"
}

variable "location" {
  type        = string
  description = "Azure region to deploy resources into."
  default     = "eastus"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to every resource created by this module."
  default = {
    environment = "dev"
    project     = "azure-iac-templates"
  }
}

variable "purge_protection_enabled" {
  type        = bool
  description = "Whether purge protection is enabled. Defaults to false for easy teardown in dev; set to true for production so deleted vaults/secrets cannot be permanently purged before the retention period elapses."
  default     = false
}
