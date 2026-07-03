# GitHub OIDC Evidence

Paste sanitized output here after identity deployment.

Recommended commands:

```bash
az ad app federated-credential list --id <application-id> --output table
az role assignment list --assignee <service-principal-object-id> --all --output table
```

## What I Validated

- [ ] GitHub deployment identity uses federated credentials, not a client secret.
- [ ] Subject claim matches the intended repository/environment.
- [ ] Role assignments are scoped to the least practical scope for the lab.
- [ ] Output is sanitized before commit.
