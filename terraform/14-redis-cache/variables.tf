variable "name_prefix" {
  type        = string
  description = "Prefix used to build resource names. Combined with a random suffix for the globally-unique Redis cache name."
  default     = "iacredis"
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

variable "sku_name" {
  type        = string
  description = "Redis cache SKU (Basic, Standard, Premium)."
  default     = "Basic"
}

variable "capacity" {
  type        = number
  description = "Cache size. For family C: 0-6 (250MB-53GB)."
  default     = 0
}
