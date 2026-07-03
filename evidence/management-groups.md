# Management Groups Evidence

Paste sanitized output here after deployment.

Recommended commands:

```bash
az account management-group list --output table
az account management-group show --name contoso-alz --expand --recurse
```

## What I Validated

- [ ] Enterprise root management group exists.
- [ ] Platform, landing zones, regulated, prod, non-prod, sandbox, and decommissioned groups are placed correctly.
- [ ] Inheritance boundaries match the design notes.
- [ ] Output is sanitized before commit.
