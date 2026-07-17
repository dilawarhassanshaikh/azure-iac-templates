variable "name_prefix" {
  type        = string
  description = "Prefix used to build the names of all resources created by this module."
  default     = "winvm"
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
  description = "Administrator username for the Windows VM."
  default     = "azureadmin"
}

variable "admin_password" {
  type        = string
  description = "Administrator password for the Windows VM. Must be 12-123 characters and meet Azure complexity requirements. No default - supply via tfvars or environment variable."
  sensitive   = true

  validation {
    condition     = length(var.admin_password) >= 12 && length(var.admin_password) <= 123
    error_message = "admin_password must be between 12 and 123 characters long."
  }
}

variable "vm_size" {
  type        = string
  description = "Azure VM size (SKU)."
  default     = "Standard_B2s"
}

variable "source_address_prefix" {
  type        = string
  description = "CIDR or '*' allowed to reach RDP (3389) on the VM's public IP. Restrict this to your own IP/CIDR in production; '*' allows the whole internet."
  default     = "*"
}
