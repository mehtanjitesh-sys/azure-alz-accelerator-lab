terraform {
  required_version = ">= 1.12, < 2.0"

  required_providers {
    alz = {
      source  = "azure/alz"
      version = "~> 0.21"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.4"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {}
}

provider "azapi" {}

provider "azurerm" {
  features {}
  subscription_id = var.platform_subscription_id
}

provider "azuread" {}

provider "alz" {
  library_overwrite_enabled = true

  library_references = [
    {
      path = "platform/alz"
      ref  = "2026.04.2"
    },
    {
      custom_url = "${path.root}/../../lib"
    }
  ]
}

