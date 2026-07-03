# Security Policy

This repository is public and intended for portfolio and learning use. It must not contain production Azure values, credentials, Terraform state, or customer-specific architecture details.

## Do Not Commit

- Real Azure tenant IDs
- Real subscription IDs
- Client secrets, certificates, private keys, SAS tokens, PATs, or storage account keys
- Terraform state files, plan files, backend access keys, or `.terraform` provider/module caches
- Real Entra user, group, service principal, or managed identity object IDs
- Real ExpressRoute circuit details, VPN shared keys, firewall allowlists, public IP addresses, private DNS zones, or production CIDR plans
- Unsanitized screenshots, CLI output, logs, or deployment evidence

## Safe To Commit

- Terraform and Bicep templates
- Sample values using obvious placeholders
- Sanitized CLI output
- Architecture diagrams without real tenant identifiers
- Documentation that explains tradeoffs and operating model decisions

## Local Values

Use `terraform.tfvars.example` as a template only. Create a private local file named `terraform.tfvars` for real values. That file is intentionally ignored by Git.

Before pushing changes, run:

```powershell
.\scripts\Test-PublicRepoSafety.ps1
```

Also review staged files:

```powershell
git diff --cached
```

## If A Secret Is Accidentally Committed

1. Revoke or rotate the secret immediately.
2. Remove the secret from the current branch.
3. Treat the value as compromised even if the commit is deleted later.
4. If needed, rewrite Git history and force-push only after understanding the impact on collaborators.

Deleting a file from a later commit does not remove it from Git history.
