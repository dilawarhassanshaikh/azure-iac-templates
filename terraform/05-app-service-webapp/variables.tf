variable "name_prefix" {
  type        = string
  description = "Prefix used to build resource names. Combined with a random suffix for the globally-unique web app name."
  default     = "iacweb"
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
  description = "App Service Plan SKU."
  default     = "B1"
}

variable "node_version" {
  type        = string
  description = "Node.js runtime version for the Linux Web App application stack."
  default     = "20-lts"
}
