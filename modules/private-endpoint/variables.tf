variable "name_prefix" {
  type        = string
  description = "Name prefix used to derive the private endpoint and connection names."
}

variable "target_resource_id" {
  type        = string
  description = "Resource ID of the PaaS resource to expose privately (e.g. a Key Vault)."
}

variable "subresource_names" {
  type        = list(string)
  description = "Private-link subresource(s) to connect (e.g. [\"vault\"] for Key Vault)."
}

variable "subnet_id" {
  type        = string
  description = "Subnet the private endpoint NIC is placed in (typically the hub private-endpoints subnet)."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group that holds the private endpoint (and the private DNS zone when created here)."
}

variable "location" {
  type        = string
  description = "Azure region in which the private endpoint is deployed."
}

variable "private_dns_zone_name" {
  type        = string
  description = "Private-link DNS zone name for the target service (e.g. privatelink.vaultcore.azure.net)."
}

variable "vnet_id" {
  type        = string
  description = "VNet linked to the private DNS zone so it can resolve the private endpoint (typically the hub VNet)."
}

variable "create_private_dns_zone" {
  type        = bool
  description = "Create the private DNS zone and vnet link. Set false to reuse an existing zone via existing_private_dns_zone_id."
  default     = true
}

variable "existing_private_dns_zone_id" {
  type        = string
  description = "Resource ID of a pre-existing private DNS zone to reuse when create_private_dns_zone is false."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to resources created by this module."
  default     = {}
}
