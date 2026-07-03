# Workload Onboarding

## Purpose

Workload onboarding turns a business request into a governed subscription or landing zone. The goal is speed with guardrails, not one-off subscription creation.

## Intake Fields

| Field | Example |
| --- | --- |
| Workload name | `claims` |
| Business unit | `Claims` |
| Environment | `dev`, `qa`, `prod` |
| Application owner | `claims-product-owner` |
| Technical owner group | `az-claims-prod-owners` |
| Reader group | `az-claims-prod-readers` |
| Cost center | `CC1045` |
| Monthly budget | `25000` |
| Data classification | `restricted` |
| Management group | `contoso-regulated-prod` |
| Connectivity | `hub-connected` |
| Private endpoints | `required` |
| Internet exposure | `none`, `front-door`, `app-gateway` |
| RTO/RPO | `4h / 15m` |
| Logging retention | `90 days hot, 1 year archive` |

## Onboarding Workflow

```text
Request
-> Validate metadata
-> Select management group
-> Vend or accept subscription
-> Apply RBAC, tags, budgets, diagnostics
-> Attach network and route tables
-> Validate policy compliance
-> Handoff outputs to app team
```

## Handoff Outputs

The app team should receive:

- Subscription scope
- Management group path
- Naming convention
- Required tags
- Owner and reader role assignments
- Budget and alert owner
- Network and DNS guidance
- CI/CD onboarding notes
- Evidence checklist
- Exception request process

## Approval Matrix

| Request | Approvers |
| --- | --- |
| Sandbox | Manager, platform |
| Non-prod workload | App owner, platform |
| Production workload | App owner, platform, security |
| Internet-facing production | App owner, platform, security architecture |
| Regulated data | App owner, platform, security, compliance |

## Example Terraform Object

```hcl
subscriptions = {
  claims_prod = {
    subscription_id          = "<subscription-id>"
    management_group_name    = "contoso-regulated-prod"
    display_name             = "Claims Production"
    environment              = "prod"
    business_unit            = "claims"
    cost_center              = "CC1045"
    data_classification      = "restricted"
    monthly_budget           = 25000
    owner_group_object_id    = "<owner-group-object-id>"
    reader_group_object_id   = "<reader-group-object-id>"
    connectivity             = "hub-connected"
    workload_route_table_ids = ["<route-table-id>"]
    tags = {
      ManagedBy = "terraform"
    }
  }
}
```

Do not commit real subscription IDs or object IDs.
