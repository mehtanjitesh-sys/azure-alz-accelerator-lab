# key-vault

Reusable module for a hardened, private Azure Key Vault intended to hold
platform automation secrets and deployment credentials. It provisions:

- An `azurerm_key_vault` with a healthcare-grade baseline:
  - `enable_rbac_authorization = true` (no legacy access policies)
  - `purge_protection_enabled = true`
  - `soft_delete_retention_days = 90`
  - `public_network_access_enabled = false`
  - `network_acls { default_action = "Deny" }`
- A diagnostic setting streaming all logs and metrics to the central Log
  Analytics workspace (same `log_analytics_workspace_id` pattern as
  `modules/hub-egress` and `modules/subscription-vending`).
- A private endpoint via `modules/private-endpoint`
  (`subresource_names = ["vault"]`), including the
  `privatelink.vaultcore.azure.net` private DNS zone and hub VNet link.
- Vault-scoped RBAC (not management-group scoped):
  - **Key Vault Administrator** for a platform admin Entra group.
  - **Key Vault Secrets User** for the `platform_deployer` service principal from
    `modules/identity-baseline` (its GitHub OIDC federated app), so CI/CD can
    read deployment secrets without standing access to manage the vault.

## Healthcare rationale

This vault addresses HIPAA Security Rule technical safeguards for the secrets and
credentials that underpin platform automation:

- **Access control (§164.312(a))** — RBAC-only authorization with least-privilege
  role assignments scoped to the vault. The deployment identity gets *Secrets
  User* (read secrets), not administrative control; break-glass and admin duties
  stay with a named admin group.
- **Transmission security & network isolation (§164.312(e))** — no public data
  plane (`public_network_access_enabled = false`, deny-by-default ACLs) and all
  access flows through a private endpoint on the hub network.
- **Integrity & availability** — purge protection plus 90-day soft-delete prevent
  accidental or malicious destruction of key material.
- **Audit controls (§164.312(b))** — diagnostic logs shipped to the central
  workspace for retention and monitoring.

## Usage

```hcl
module "platform_key_vault" {
  source = "../../modules/key-vault"

  prefix                          = var.enterprise_id
  name                            = "kv-${var.enterprise_id}-plat"
  resource_group_name             = "rg-${var.enterprise_id}-platform-secrets"
  location                        = var.location
  log_analytics_workspace_id      = var.log_analytics_workspace_id
  private_endpoint_subnet_id      = module.hub_egress.private_endpoints_subnet_id
  private_endpoint_vnet_id        = module.hub_egress.hub_vnet_id
  key_vault_admin_group_object_id = var.platform_admin_group_object_id
  platform_deployer_principal_id  = module.identity_baseline.platform_deployer_object_id
  tags                            = var.default_tags
}
```

## Inputs

| Name | Description | Required |
| --- | --- | --- |
| `prefix` | Name prefix for derived resources | yes |
| `name` | Key Vault name (globally unique, 3-24 chars) | yes |
| `resource_group_name` | Resource group for the vault | yes |
| `location` | Azure region | yes |
| `log_analytics_workspace_id` | Central workspace for diagnostics | yes |
| `private_endpoint_subnet_id` | Subnet for the vault private endpoint | yes |
| `private_endpoint_vnet_id` | VNet linked to the vault private DNS zone | yes |
| `key_vault_admin_group_object_id` | Group granted Key Vault Administrator | yes |
| `platform_deployer_principal_id` | SP granted Key Vault Secrets User | yes |
| `sku_name` | Vault SKU (default `standard`) | no |
| `soft_delete_retention_days` | Soft-delete retention (default `90`) | no |
| `private_dns_zone_name` | Private-link DNS zone (default vaultcore) | no |
| `create_private_dns_zone` | Create the zone + link (default `true`) | no |
| `existing_private_dns_zone_id` | Reuse an existing zone | no |
| `tags` | Resource tags | no |

## Outputs

| Name | Description |
| --- | --- |
| `key_vault_id` | Resource ID of the vault |
| `key_vault_uri` | Vault URI |
| `resource_group_name` | Resource group holding the vault |
| `private_endpoint_id` | Private endpoint resource ID |
| `private_endpoint_ip_address` | Private endpoint IP |
