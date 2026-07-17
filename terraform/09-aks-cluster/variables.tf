variable "name_prefix" {
  type        = string
  description = "Prefix used to build the names of all resources created by this module."
  default     = "iacaks"
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

variable "dns_prefix" {
  type        = string
  description = "DNS prefix for the AKS cluster's API server."
  default     = "iacaks"
}

variable "node_count" {
  type        = number
  description = "Number of nodes in the default node pool."
  default     = 2
}
