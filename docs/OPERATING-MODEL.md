# Operating Model

An Azure Landing Zone is only useful if the operating model is clear.

## Ownership

| Area | Owner |
| --- | --- |
| Management groups | Cloud platform team |
| Policy and compliance controls | Security and governance team |
| Connectivity hub | Network platform team |
| Identity and privileged access | IAM team |
| Workload subscriptions | Application team |
| Subscription vending process | Cloud platform team |
| Budget ownership | Business/application owner |
| DR/RTO/RPO | Application owner with platform review |

## Policy Exceptions

Policy exemptions should be:

- Requested by the application owner
- Reviewed by security and platform engineering
- Time-boxed
- Linked to a risk record or ticket
- Revalidated before expiration

## Logging Retention

Baseline recommendation:

- Activity logs: central Log Analytics
- Security logs: central Log Analytics and Sentinel where licensed
- Retention: map to regulatory requirement, commonly 90 days hot plus archive for 1 year or more
- Production regulated workloads: define retention explicitly before onboarding

## Subscription Vending Flow

1. Application team submits request.
2. Platform team validates required metadata.
3. Subscription is created or existing subscription is accepted.
4. Subscription is placed into the correct management group.
5. RBAC, budget, tags, diagnostics, and connectivity are applied.
6. App team receives onboarding outputs.
7. Compliance state is checked before workload deployment.

## RTO/RPO

Landing-zone vending should capture workload criticality:

- Tier 0/1: business-critical, formal DR design required
- Tier 2: production, backup and recovery runbook required
- Tier 3: nonproduction, lower recovery expectation
- Sandbox: no guaranteed recovery

