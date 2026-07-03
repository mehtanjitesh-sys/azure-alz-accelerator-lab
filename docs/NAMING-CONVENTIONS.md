# Naming Conventions

## Purpose

This lab uses predictable names so a reviewer can understand the platform design quickly. In a real enterprise, naming should be enforced with Azure Policy where practical and reviewed during subscription vending.

## Standard Tokens

| Token | Meaning | Example |
| --- | --- | --- |
| `enterprise` | Company or platform code | `contoso` |
| `workload` | Application or platform capability | `claims`, `payments`, `hub` |
| `env` | Environment | `dev`, `qa`, `prod`, `sandbox` |
| `region` | Region short code | `eus`, `eus2`, `cus` |
| `instance` | Sequence number | `001` |

## Resource Patterns

| Resource | Pattern | Example |
| --- | --- | --- |
| Management group | `<enterprise>-<scope>` | `contoso-regulated-prod` |
| Resource group | `rg-<enterprise>-<workload>-<env>-<region>` | `rg-contoso-connectivity-prod-eus` |
| VNet | `vnet-<enterprise>-<workload>-<env>-<region>` | `vnet-contoso-hub-prod-eus` |
| Subnet | `snet-<purpose>-<env>` | `snet-firewall-prod` |
| Route table | `rt-<workload>-<env>-forced-egress` | `rt-claims-prod-forced-egress` |
| Azure Firewall | `azfw-<enterprise>-hub-<env>-<region>` | `azfw-contoso-hub-prod-eus` |
| Private DNS Resolver | `pdnsr-<enterprise>-hub-<env>-<region>` | `pdnsr-contoso-hub-prod-eus` |
| Log Analytics | `law-<enterprise>-platform-<env>-<region>` | `law-contoso-platform-prod-eus` |
| Front Door | `afd-<enterprise>-<workload>-<env>` | `afd-contoso-bluegreen-prod` |
| Managed identity | `id-<enterprise>-<purpose>-<env>` | `id-contoso-github-prod` |
| Budget | `budget-<workload>-<env>-monthly` | `budget-claims-prod-monthly` |

## Environment Codes

| Environment | Code |
| --- | --- |
| Development | `dev` |
| QA | `qa` |
| Production | `prod` |
| Sandbox | `sandbox` |
| Shared platform | `platform` |

## Required Tags

| Tag | Example |
| --- | --- |
| `Environment` | `prod` |
| `BusinessUnit` | `Claims` |
| `CostCenter` | `CC1045` |
| `Owner` | `az-claims-prod-owners` |
| `DataClassification` | `restricted` |
| `ManagedBy` | `terraform` |
| `LandingZone` | `contoso-regulated-prod` |

## Storage Names

Storage names must be globally unique, lowercase, and 3-24 characters.

Use:

```text
st<enterprise><workload><env><instance>
```

Example:

```text
stcontosoclaimsprod01
```

## Review Rules

- Do not include personal names in resource names.
- Do not encode secrets or real customer names.
- Keep names stable across redeployments.
- Use tags for metadata that does not belong in the name.
