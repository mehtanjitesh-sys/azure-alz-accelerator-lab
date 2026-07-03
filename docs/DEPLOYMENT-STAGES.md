# Deployment Stages

The lab root module shows the full design in one place. A production implementation should split the deployment into controlled stages.

```text
00-bootstrap-state
01-alz-tenant
02-connectivity
03-management
04-subscription-vending
05-workload-network-onboarding
06-workload-reference
```

## 00-bootstrap-state

Creates the storage account, container, and access model for Terraform state.

## 01-alz-tenant

Deploys the ALZ module, management group hierarchy, policy assignments, role definitions, and subscription placement.

## 02-connectivity

Deploys the hub network, Azure Firewall, firewall policy, DNS resolver, diagnostics, and hub-to-spoke peering.

## 03-management

Deploys central monitoring, Sentinel/Defender configuration, automation, and shared operational services.

## 04-subscription-vending

Accepts subscription request metadata and applies placement, tags, RBAC, budget, diagnostics, and onboarding outputs.

## 05-workload-network-onboarding

Runs with the correct workload subscription context to create spoke-side peering, forced-egress route tables, and subnet route table associations.

## 06-workload-reference

Deploys reference workloads such as the blue/green Front Door example.

## Why This Matters

Tenant-scope ALZ, connectivity, subscription vending, and workload networking have different owners and blast radiuses. Splitting stages makes approvals, rollback, and audit evidence much cleaner.

