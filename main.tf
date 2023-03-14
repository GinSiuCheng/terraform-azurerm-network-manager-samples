terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource group 
resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}
