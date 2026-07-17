variable "name_prefix" {
  type        = string
  description = "Prefix used to build the names of all resources created by this module."
  default     = "linuxvm"
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
  description = "Administrator username for the Linux VM."
  default     = "azureuser"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key (e.g. contents of ~/.ssh/id_rsa.pub) used for admin_username. Password authentication is disabled."
}

variable "vm_size" {
  type        = string
  description = "Azure VM size (SKU)."
  default     = "Standard_B2s"
}

variable "source_address_prefix" {
  type        = string
  description = "CIDR or '*' allowed to reach SSH (22) on the VM's public IP. Restrict this to your own IP/CIDR in production; '*' allows the whole internet."
  default     = "*"
}
