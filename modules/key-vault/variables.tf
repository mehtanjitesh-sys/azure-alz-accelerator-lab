variable "prefix" {
  type        = string
  description = "Name prefix used to derive resource names."
}

variable "name" {
  type        = string
  description = "Key Vault name (globally unique, 3-24 chars, alphanumeric and hyphens)."
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "sku_name" {
  type    = string
  default = "standard"
}

variable "soft_delete_retention_days" {
  type    = number
  default = 90
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
}

variable "platform_deployer_principal_id" {
  type        = string
  description = "Object ID of the platform_deployer service principal (identity-baseline GitHub OIDC app) granted Key Vault Secrets User."
}

variable "tags" {
  type    = map(string)
  default = {}
}
