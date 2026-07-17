variable "name_prefix" {
  type        = string
  description = "Prefix used to build resource names. Combined with a random suffix for the globally-unique Cosmos DB account name."
  default     = "iaccosmos"
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
