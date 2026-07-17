variable "name_prefix" {
  type        = string
  description = "Prefix used to build the names of all resources created by this module."
  default     = "iaclaw"
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

variable "retention_in_days" {
  type        = number
  description = "Data retention period, in days, for the Log Analytics workspace."
  default     = 30
}
