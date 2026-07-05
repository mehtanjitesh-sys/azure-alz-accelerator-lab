variable "prefix" {
  type        = string
  description = "Name prefix used to derive resource names."
}

variable "name" {
  type        = string
  description = "Key Vault name (globally unique, 3-24 chars, alphanumeric and hyphens)."

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]{1,22}[a-zA-Z0-9]$", var.name))
    error_message = "Key Vault name must be 3-24 characters, contain only alphanumerics and hyphens, and start with a letter."
  }
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group created to hold the Key Vault and its private endpoint."
}

variable "location" {
  type        = string
  description = "Azure region in which the Key Vault and its resource group are deployed."
}

variable "sku_name" {
  type        = string
  description = "Key Vault SKU tier."
  default     = "standard"

  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "sku_name must be either \"standard\" or \"premium\"."
  }
}

variable "soft_delete_retention_days" {
  type        = number
  description = "Number of days deleted vault items are retained before purge (7-90)."
  default     = 90

  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "soft_delete_retention_days must be between 7 and 90."
  }
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Central Log Analytics workspace resource ID for diagnostics."
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "Subnet for the Key Vault private endpoint (typically the hub private-endpoints subnet)."
}

variable "private_endpoint_vnet_id" {
  type        = string
  description = "VNet linked to the vault private DNS zone (typically the hub VNet)."
}

variable "private_dns_zone_name" {
  type    = string
  default = "privatelink.vaultcore.azure.net"
}

variable "create_private_dns_zone" {
  type    = bool
  default = true
}

variable "existing_private_dns_zone_id" {
  type    = string
  default = null
}

variable "key_vault_admin_group_object_id" {
  type        = string
  description = "Entra group granted Key Vault Administrator on this vault."

  validation {
    condition     = length(trimspace(var.key_vault_admin_group_object_id)) > 0
    error_message = "key_vault_admin_group_object_id must not be empty."
  }
}

variable "platform_deployer_principal_id" {
  type        = string
  description = "Object ID of the platform_deployer service principal (identity-baseline GitHub OIDC app) granted Key Vault Secrets User."

  validation {
    condition     = length(trimspace(var.platform_deployer_principal_id)) > 0
    error_message = "platform_deployer_principal_id must not be empty."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to resources created by this module."
  default     = {}
}
