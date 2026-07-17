variable "name_prefix" {
  type        = string
  description = "Prefix used to build resource names. Combined with a random suffix for the globally-unique PostgreSQL server name."
  default     = "iacpsql"
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

variable "admin_login" {
  type        = string
  description = "Administrator login name for the PostgreSQL flexible server. No default - supply via tfvars."
  sensitive   = true
}

variable "admin_password" {
  type        = string
  description = "Administrator password for the PostgreSQL flexible server. No default - supply via tfvars or environment variable."
  sensitive   = true
}

variable "sku_name" {
  type        = string
  description = "Compute/storage SKU for the flexible server."
  default     = "B_Standard_B1ms"
}

variable "storage_mb" {
  type        = number
  description = "Allocated storage in MB."
  default     = 32768
}

variable "allow_azure_services" {
  type        = bool
  description = "Whether to add a firewall rule allowing other Azure services to reach the server (0.0.0.0-0.0.0.0)."
  default     = true
}
