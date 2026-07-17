variable "name_prefix" {
  type        = string
  description = "Prefix used to build resource names. Combined with a random suffix for the globally-unique storage account name (lowercase alphanumeric only)."
  default     = "iacsa"
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

variable "account_tier" {
  type        = string
  description = "Storage account performance tier."
  default     = "Standard"
}

variable "account_replication_type" {
  type        = string
  description = "Storage account replication type (LRS, GRS, RAGRS, ZRS, etc)."
  default     = "LRS"
}
