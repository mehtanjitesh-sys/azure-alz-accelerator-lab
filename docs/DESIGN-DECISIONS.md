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
- Forced egress route table
- `0.0.0.0/0` next hop to the firewall private IP
- Hub-to-spoke and spoke-to-hub peering
- Private DNS Resolver inbound and outbound endpoints

This supports the client requirement for hub-based egress and no direct spoke internet.

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

## 6. Blue/Green Reference

The blue/green module uses Azure Front Door as the traffic-control layer.

The intended release model is:

1. Deploy to inactive environment.
2. Validate `/health`.
3. Shift traffic by changing origin weights or route target.
4. Keep previous environment warm for rollback.
5. Promote after validation.

Stateful workloads still require separate database migration and rollback decisions.

