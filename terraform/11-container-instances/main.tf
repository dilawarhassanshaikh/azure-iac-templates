terraform {
  required_version = ">= 1.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "suffix" {
  length  = 6
  lower   = true
  upper   = false
  numeric = true
  special = false
}

resource "azurerm_resource_group" "this" {
  name     = "${var.name_prefix}-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_container_group" "this" {
  name                = "${var.name_prefix}-aci"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  os_type             = "Linux"
  ip_address_type     = "Public"
  dns_name_label      = "${var.name_prefix}-${random_string.suffix.result}"
  tags                = var.tags

  container {
    name   = "app"
    image  = var.image
    cpu    = var.cpu
    memory = var.memory

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}
