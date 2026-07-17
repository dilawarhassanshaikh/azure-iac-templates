variable "name_prefix" {
  type        = string
  description = "Prefix used to build resource names. Combined with a random suffix for the globally-unique SQL server name."
  default     = "iacsql"
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
  description = "Administrator login name for the Azure SQL logical server. No default - supply via tfvars."
  sensitive   = true
}

variable "admin_password" {
  type        = string
  description = "Administrator password for the Azure SQL logical server. No default - supply via tfvars or environment variable."
  sensitive   = true
}

variable "sku_name" {
  type        = string
  description = "Database SKU (e.g. Basic, S0, GP_S_Gen5_2)."
  default     = "Basic"
}

variable "max_size_gb" {
  type        = number
  description = "Maximum database size in GB."
  default     = 2
}

variable "allow_azure_services" {
  type        = bool
  description = "Whether to add a firewall rule allowing other Azure services to reach the SQL server (0.0.0.0-0.0.0.0)."
  default     = true
}
