# Environment Strategy

## Purpose

This repo models an ALZ-style platform where environment separation is handled through management groups, subscriptions, policy inheritance, and CI/CD approval gates.

## Environment Model

| Environment | Management Group | Subscription Pattern | Control Level |
| --- | --- | --- | --- |
| Sandbox | `<enterprise>-sandbox` | Time-boxed sandbox subscription | Budget and expiration controls |
| DEV/QA | `<enterprise>-non-prod` | Shared or dedicated non-prod workload subscriptions | Standard guardrails |
| PROD | `<enterprise>-regulated-prod` or `<enterprise>-prod` | Dedicated production subscription | Strict policy, logging, PIM |
| Platform | `<enterprise>-platform` | Connectivity, identity, management subscriptions | Platform team controlled |
| Decommissioned | `<enterprise>-decommissioned` | Retained inactive subscriptions | Locked down |

## Promotion Flow

```text
DEV -> QA -> PROD
```

Promotion should require:

- Terraform plan or Bicep what-if
- Security scan
- Cost review
- Policy compliance review
- Rollback note
- Human approval for production

## Network Expectations

| Environment | Connectivity |
| --- | --- |
| Sandbox | Isolated unless approved |
| DEV/QA | Hub-connected where integration requires it |
| PROD | Hub-spoke, forced egress, private endpoint preference |
| Platform | Hub, firewall, DNS, observability, identity controls |

## Evidence Expectations

Each environment should capture sanitized evidence for:

- Management group placement
- RBAC assignment
- Budget
- Route tables and firewall egress
- Diagnostic settings
- Policy compliance
