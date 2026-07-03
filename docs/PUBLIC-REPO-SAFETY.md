# Public Repo Safety Checklist

This repo is designed to show Azure Landing Zone thinking without exposing a real Azure estate.

## Portfolio Boundary

The repo should prove that the author understands:

- ALZ hierarchy and subscription placement
- Hub-spoke egress and DNS patterns
- Identity, PIM, break-glass, and federated deployment identity decisions
- CI/CD approval gates
- Cost, validation, cleanup, and operational evidence

It should not reveal:

- Real tenant or subscription identifiers
- Real object IDs for users, groups, or service principals
- Real network topology from an employer or client
- Real firewall rules, DNS forwarding targets, ExpressRoute details, or IP allowlists
- Terraform state or deployment secrets

## Pre-Push Checklist

- `terraform.tfvars` is local only and not staged.
- No `.tfstate`, `.tfplan`, `.terraform`, or `.alzlib` files are staged.
- Screenshots and CLI outputs are sanitized.
- Subscription IDs use placeholder GUIDs such as `00000000-0000-0000-0000-000000000000`.
- Object IDs use placeholder GUIDs such as `11111111-1111-1111-1111-111111111111`.
- Real organization names are replaced with lab names such as `contoso` or `example`.
- GitHub Actions uses OIDC and repository/environment variables, not committed credentials.

## Recommended GitHub Settings

- Enable GitHub secret scanning.
- Enable push protection if available.
- Protect `main`.
- Require pull request review before merge.
- Require the Terraform validation workflow to pass.
- Use GitHub Environments for `dev`, `qa`, and `prod` approvals.

## Evidence Sanitization

When adding evidence, replace sensitive values before commit:

```text
tenantId: <tenant-id>
subscriptionId: <subscription-id>
principalId: <principal-id>
publicIpAddress: <public-ip>
expressRouteCircuitId: <expressroute-circuit-id>
```

Keep detailed raw evidence outside the repo, or store it in a private repository.
