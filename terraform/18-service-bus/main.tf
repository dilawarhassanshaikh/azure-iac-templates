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

resource "azurerm_servicebus_namespace" "this" {
  name                = "${var.name_prefix}-sbns-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = var.sku
  tags                = var.tags
}

resource "azurerm_servicebus_queue" "this" {
  name                  = "${var.name_prefix}-queue"
  namespace_id          = azurerm_servicebus_namespace.this.id
  max_size_in_megabytes = var.max_size_in_megabytes
}
