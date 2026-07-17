variable "name_prefix" {
  type        = string
  description = "Prefix used to build resource names. Combined with a random suffix for the globally-unique endpoint name."
  default     = "iacafd"
}

variable "location" {
  type        = string
  description = "Azure region for the resource group (Front Door itself is a global service)."
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

variable "origin_host_name" {
  type        = string
  description = "Hostname of the origin to front (e.g. a web app's default hostname like myapp.azurewebsites.net, or a storage static website hostname). No default - supply via tfvars."
}
