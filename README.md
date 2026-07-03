# Azure ALZ Accelerator Lab

This repository is a portfolio-grade Azure Landing Zone implementation focused on the current Microsoft Azure Landing Zone Terraform pattern, not a hand-rolled management-group-only demo.

It uses the Microsoft Azure Verified Module pattern for Azure Landing Zones:

- `Azure/avm-ptn-alz/azurerm`
- Azure Landing Zones library references through the `azure/alz` provider
- Custom ALZ architecture definition for enterprise segmentation
- Subscription placement through the ALZ module
- Separate Terraform modules for the platform patterns that usually sit around ALZ

## Deployment Status

This repository is validated in a no-Azure, plan-first mode: formatting and syntax validation run via `scripts/Run-PredeploymentValidation.ps1` and CI without requiring a live Azure backend.

Actual infrastructure deployment is intentionally gated and follows the stage model in `docs/DEPLOYMENT-STAGES.md`:

- Trigger: manual/staged execution, not automatic on push
- Requires enterprise-specific inputs (Tenant ID, billing scope, subscription vending permissions, connectivity/DNS)
- Requires configured deployment identity and environment approval

This balanced posture keeps the lab safe to publish publicly while remaining deployable once tenant-specific inputs are configured.

## What This Demonstrates

| Capability | Implemented In |
| --- | --- |
| Microsoft ALZ Terraform Accelerator-style implementation | `environments/alz-platform` |
| Custom management group hierarchy beyond CAF defaults | `lib/enterprise.alz_architecture_definition.yaml` |
| Subscription placement through ALZ | `environments/alz-platform/main.tf` |
| Hub-controlled egress | `modules/hub-egress` |
| Route tables with `0.0.0.0/0` to Azure Firewall | `modules/workload-network-onboarding` |
| Hub/spoke peering | `modules/hub-egress` |
| Private DNS Resolver scaffolding | `modules/hub-egress` |
| Subscription vending object model | `modules/subscription-vending` |
| RBAC, budgets, tags, diagnostics for vended subscriptions | `modules/subscription-vending` |
| Spoke-side peering and subnet route association | `modules/workload-network-onboarding` |
| Identity baseline examples | `modules/identity-baseline` |
| Federated deployment identity | `modules/identity-baseline` |
| Blue/green deployment reference | `modules/blue-green-frontdoor` |
| GitHub Actions plan/apply workflow | `.github/workflows/terraform-alz.yml` |

## Repo Layout

```text
.
|-- environments/
|   `-- alz-platform/
|       |-- main.tf
|       |-- providers.tf
|       |-- variables.tf
|       |-- outputs.tf
|       `-- terraform.tfvars.example
|-- lib/
|   `-- enterprise.alz_architecture_definition.yaml
|-- modules/
|   |-- hub-egress/
|   |-- subscription-vending/
|   |-- workload-network-onboarding/
|   |-- identity-baseline/
|   `-- blue-green-frontdoor/
|-- evidence/
|   |-- management-groups.md
|   |-- subscription-placement.md
|   |-- hub-egress.md
|   |-- github-oidc.md
|   `-- blue-green.md
|-- docs/
|   |-- DESIGN-DECISIONS.md
|   |-- OPERATING-MODEL.md
|   `-- VALIDATION.md
`-- .github/workflows/
    `-- terraform-alz.yml
```

## Important Positioning

This is an ALZ Accelerator-oriented implementation scaffold. It is designed to prove that I understand the Microsoft ALZ Terraform implementation model and the enterprise design patterns around it.

## Public Repo Safety

This repository is public by design. It uses placeholder values only and must not contain real Azure tenant IDs, subscription IDs, Entra object IDs, secrets, state files, plan files, production network details, or unsanitized screenshots.

Before pushing changes, run:

```powershell
.\scripts\Test-PublicRepoSafety.ps1
```

For the full checklist, see [Public Repo Safety](docs/PUBLIC-REPO-SAFETY.md) and [Security Policy](SECURITY.md).

## Architecture Review

For a professional gap assessment and hardening roadmap, see [Repo Review Recommendations](docs/REPO-REVIEW-RECOMMENDATIONS.md).

For portfolio proof, use [Validation Evidence](docs/VALIDATION-EVIDENCE.md) and commit only sanitized outputs.

For no-Azure syntax confidence, run the `Predeployment Validation` GitHub Actions workflow or execute `scripts/Run-PredeploymentValidation.ps1` locally. This validates Terraform formatting, module initialization without a backend, and Terraform syntax without claiming a real Azure deployment.

## Deployment Stages

The main root module remains useful for lab review, but production rollout should follow the stage model in [Deployment Stages](docs/DEPLOYMENT-STAGES.md).

Starter-pack standards:

- [Naming Conventions](docs/NAMING-CONVENTIONS.md)
- [Environment Strategy](docs/ENVIRONMENT-STRATEGY.md)
- [Workload Onboarding](docs/WORKLOAD-ONBOARDING.md)

It still requires real enterprise inputs before production use:

- Tenant ID
- Billing scope
- Existing subscription IDs or vending permissions
- Entra group object IDs
- Connectivity subscription ID
- Log Analytics workspace ID
- DNS forwarding targets
- Allowed regions
- Compliance control mapping
- A generated ALZ architecture definition if changing the default `contoso` enterprise ID

## Why This Is Different From A Custom Landing Zone

A custom landing zone might create management groups directly with `azurerm_management_group`.

This repo instead uses the ALZ module and library model:

- Architecture definition file controls hierarchy.
- Archetypes drive policy and governance inheritance.
- Subscription placement is passed into the ALZ module.
- Policy assignment modifications and defaults are handled through ALZ module inputs.

That distinction matters when a client specifically asks for Microsoft ALZ Accelerator experience.
