variable "name_prefix" {
  type        = string
  description = "Prefix used to build resource names. Combined with a random suffix for the globally-unique Service Bus namespace name."
  default     = "iacsb"
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

variable "sku" {
  type        = string
  description = "Service Bus namespace SKU (Basic, Standard, Premium)."
  default     = "Standard"
}

variable "max_size_in_megabytes" {
  type        = number
  description = "Maximum size of the queue in megabytes."
  default     = 1024
}
