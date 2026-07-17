variable "name_prefix" {
  type        = string
  description = "Prefix used to build the names of all resources created by this module."
  default     = "iacagw"
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
  description = "Application Gateway SKU name and tier (e.g. WAF_v2, Standard_v2)."
  default     = "WAF_v2"
}

variable "autoscale_min_capacity" {
  type        = number
  description = "Minimum autoscale capacity (instance count)."
  default     = 1
}

variable "autoscale_max_capacity" {
  type        = number
  description = "Maximum autoscale capacity (instance count)."
  default     = 3
}

variable "backend_ip_addresses" {
  type        = list(string)
  description = "Placeholder IP addresses for the backend address pool. Replace with real backend targets (e.g. VM/VMSS private IPs) after deployment."
  default     = ["10.1.2.4"]
}
