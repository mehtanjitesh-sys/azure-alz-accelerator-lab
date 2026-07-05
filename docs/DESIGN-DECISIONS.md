# Design Decisions

## 1. ALZ Module Instead Of Raw Management Groups

The platform environment uses `Azure/terraform-azurerm-avm-ptn-alz/azurerm` so the landing-zone hierarchy, policy assignments, policy definitions, policy role assignments, and subscription placement follow the Microsoft ALZ library model.

This is different from creating `azurerm_management_group` resources directly. Direct resources can prove Azure knowledge, but the ALZ module proves familiarity with the Microsoft-supported Terraform implementation pattern.

## 2. Expanded Enterprise Hierarchy

The hierarchy separates:

- Platform services: connectivity, identity, management
- Regulated workloads: production and nonproduction
- Internal workloads: production and nonproduction
- Vendor-managed workloads
- SaaS-connected workloads
- Sandbox
- Quarantine
- Decommissioning

These boundaries exist because different policies should inherit at different scopes. A regulated production workload should not inherit the same controls as a sandbox or SaaS integration subscription.

## 3. Hub-Controlled Egress

Spokes do not receive direct internet egress by default.

The hub module creates:

- Azure Firewall
- Firewall Policy
- Hub-to-spoke peering
- Private DNS Resolver inbound and outbound endpoints

The workload network onboarding module creates the spoke-side peering, forced egress route table, `0.0.0.0/0` next hop, and subnet route table association. This split reflects real enterprise ownership: the network platform team owns the hub, while subscription onboarding applies spoke controls with the correct workload subscription context.

## 4. Subscription Vending

Subscription vending is modeled as an object, not a Word document.

Each vended subscription includes:

- Management group placement
- Environment
- Business unit
- Cost center
- Data classification
- Monthly budget
- Owner group
- Reader group
- Connectivity model
- Workload tags

The ALZ module handles placement. The vending module handles operational controls such as RBAC, budgets, diagnostics, and forced-egress preparation.

## 5. Identity Baseline

The identity module includes:

- GitHub federated deployment identity
- Management-group role assignments
- Platform admin group
- Security reader group
- Break-glass owner assignment

In production, active owner assignments should be minimized and moved toward PIM eligibility. Break-glass accounts should be cloud-only, excluded from Conditional Access policies that could lock out the tenant, and heavily monitored.

## 6. Private Endpoints And Platform Key Vault

Private endpoints and Key Vault RBAC are now implemented, closing a gap where the
accelerator had zero `azurerm_private_endpoint` and zero `azurerm_key_vault`
resources despite positioning itself as a healthcare-grade reference.

- `modules/private-endpoint` is a reusable module that fronts any PaaS resource
  with a private endpoint, the matching `privatelink.*` Private DNS Zone, a hub
  VNet link, and a `private_dns_zone_group`. It consumes the new
  `private_endpoints_subnet_id` / `hub_vnet_id` outputs from `modules/hub-egress`.
- `modules/key-vault` provisions a hardened vault (`enable_rbac_authorization`,
  `purge_protection_enabled`, 90-day soft delete, `public_network_access_enabled
  = false`, deny-by-default network ACLs), a diagnostic setting to the central
  workspace, and its own private endpoint (`subresource_names = ["vault"]`).

RBAC is deliberately **vault-scoped**, not management-group scoped: the platform
admin group receives *Key Vault Administrator*, and the `platform_deployer`
GitHub OIDC service principal from `modules/identity-baseline` receives *Key
Vault Secrets User*. This keeps CI/CD able to read platform automation secrets
without standing administrative control, aligning with HIPAA §164.312 access-
control and transmission-security technical safeguards.

## 7. Blue/Green Reference

The blue/green module uses Azure Front Door as the traffic-control layer.

The intended release model is:

1. Deploy to inactive environment.
2. Validate `/health`.
3. Shift traffic by changing origin weights or route target.
4. Keep previous environment warm for rollback.
5. Promote after validation.

Stateful workloads still require separate database migration and rollback decisions.
