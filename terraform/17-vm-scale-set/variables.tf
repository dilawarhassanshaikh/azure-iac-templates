variable "name_prefix" {
  type        = string
  description = "Prefix used to build the names of all resources created by this module."
  default     = "iacvmss"
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

variable "admin_username" {
  type        = string
  description = "Administrator username for scale set instances."
  default     = "azureuser"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key (e.g. contents of ~/.ssh/id_rsa.pub) used for admin_username. Password authentication is disabled."
}

variable "sku" {
  type        = string
  description = "VM size (SKU) for scale set instances."
  default     = "Standard_B2s"
}

variable "instances" {
  type        = number
  description = "Number of VM instances in the scale set."
  default     = 2
}
