# private-endpoint

Reusable module that gives an Azure PaaS resource a private, VNet-internal
address and takes it off the public internet. It provisions:

- An `azurerm_private_endpoint` for `target_resource_id`, connected to the
  requested `subresource_names` (for example `["vault"]` for Key Vault).
- The matching `privatelink.*` Azure Private DNS Zone (when
  `create_private_dns_zone = true`) and a virtual network link so the hub VNet
  resolves the service name to the private IP instead of the public endpoint.
- A `private_dns_zone_group` on the endpoint so Azure keeps the A record in sync
  with the endpoint NIC automatically.

If the private DNS zone already exists (a common pattern once a platform hosts
many private endpoints), set `create_private_dns_zone = false` and pass
`existing_private_dns_zone_id`.

## Healthcare rationale

For HIPAA/HITRUST landing zones, ePHI-adjacent platform services must not be
reachable over the public internet. Private endpoints implement the HIPAA
Security Rule transmission-security and access-control technical safeguards by:

- Forcing all access to the target resource across the private RFC 1918 network,
  where it is subject to the hub firewall and forced-egress controls in
  `modules/hub-egress` / `modules/workload-network-onboarding`.
- Pairing with `public_network_access_enabled = false` on the target so there is
  no internet-facing data plane at all.
- Keeping name resolution inside the tenant via the private DNS zone linked to
  the hub VNet and its Private DNS Resolver, preventing DNS exfiltration and
  accidental resolution to the public endpoint.

## Usage

```hcl
module "keyvault_private_endpoint" {
  source = "../private-endpoint"

  name_prefix           = "contoso-kv-platform"
  target_resource_id    = azurerm_key_vault.this.id
  subresource_names     = ["vault"]
  subnet_id             = module.hub_egress.private_endpoints_subnet_id
  vnet_id               = module.hub_egress.hub_vnet_id
  resource_group_name   = azurerm_resource_group.this.name
  location              = var.location
  private_dns_zone_name = "privatelink.vaultcore.azure.net"
  tags                  = var.tags
}
```

## Inputs

| Name | Description | Required |
| --- | --- | --- |
| `name_prefix` | Prefix for endpoint / connection names | yes |
| `target_resource_id` | Resource ID of the PaaS resource to expose | yes |
| `subresource_names` | Private-link subresource(s), e.g. `["vault"]` | yes |
| `subnet_id` | Subnet for the private endpoint NIC | yes |
| `vnet_id` | VNet linked to the private DNS zone | yes |
| `resource_group_name` | Resource group for the endpoint / zone | yes |
| `location` | Azure region | yes |
| `private_dns_zone_name` | Private-link DNS zone name | yes |
| `create_private_dns_zone` | Create zone + vnet link (default `true`) | no |
| `existing_private_dns_zone_id` | Reuse an existing zone when not creating | no |
| `tags` | Resource tags | no |

## Outputs

| Name | Description |
| --- | --- |
| `private_endpoint_id` | Resource ID of the private endpoint |
| `private_ip_address` | Private IP assigned to the endpoint NIC |
| `private_dns_zone_id` | Resource ID of the (created or reused) DNS zone |
