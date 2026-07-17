terraform {
  required_version = ">= 1.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "this" {
  name     = "${var.name_prefix}-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = "${var.name_prefix}-aks"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  dns_prefix          = var.dns_prefix
  tags                = var.tags

  default_node_pool {
    name       = "default"
    vm_size    = "Standard_DS2_v2"
    node_count = var.node_count
  }

  identity {
    type = "SystemAssigned"
  }
}
