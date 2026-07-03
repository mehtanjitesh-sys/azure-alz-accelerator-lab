# Validation Evidence

This repo should prove more than syntax. The evidence should show that the ALZ pattern, platform controls, and operating tradeoffs were validated safely.

## Evidence Standard

Capture sanitized evidence for:

- Public repo safety scan
- Terraform init with `-backend=false`
- Terraform validate
- Optional sanitized Terraform plan
- ALZ management group hierarchy
- Subscription placement/vending metadata
- Hub-spoke egress route behavior
- Azure Firewall diagnostics
- Private DNS Resolver forwarding rules
- GitHub OIDC identity setup
- Blue/green Front Door reference
- Cleanup and cost-control notes

## Sanitizing Output

Save raw output outside the repo or under ignored `evidence/raw`, then sanitize it:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\Sanitize-Evidence.ps1 `
  -InputPath .\evidence\raw\terraform-validate.txt `
  -OutputPath .\evidence\terraform-validate-sanitized.md
```

Run the public repo safety check before commit:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\Test-PublicRepoSafety.ps1
```

## Evidence Checklist

| Area | Evidence File | Status |
| --- | --- | --- |
| Public repo safety | `evidence/public-repo-safety-sanitized.md` | Pending |
| Terraform validate | `evidence/terraform-validate-sanitized.md` | Pending |
| Terraform plan | `evidence/terraform-plan-sanitized.md` | Pending |
| Management groups | `evidence/management-groups.md` | Template |
| Subscription placement | `evidence/subscription-placement.md` | Template |
| Hub egress | `evidence/hub-egress.md` | Template |
| GitHub OIDC | `evidence/github-oidc.md` | Template |
| Blue/green | `evidence/blue-green.md` | Template |

Replace `Pending` or `Template` only after running commands and sanitizing evidence.

## What I Validated

- [ ] ALZ module configuration initializes and validates.
- [ ] Custom management group architecture is understood and documented.
- [ ] Hub egress pattern forces spoke traffic through Azure Firewall.
- [ ] Subscription vending is modeled as data and controls, not just documentation.
- [ ] Identity examples use OIDC, PIM notes, and break-glass guidance without committing secrets.
- [ ] Cleanup, cost warning, and non-production limitations are documented.
