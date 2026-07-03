# Subscription Placement Evidence

Paste sanitized output here after subscription placement.

Recommended commands:

```bash
az account management-group subscription show-sub-under-mg --name contoso-regulated-prod
az role assignment list --scope /subscriptions/<subscription-id> --output table
az consumption budget list --scope /subscriptions/<subscription-id> --output table
```

## What I Validated

- [ ] Subscription is associated with the intended management group.
- [ ] Owner and reader groups are assigned at the correct scope.
- [ ] Budget metadata exists for the vended subscription.
- [ ] Output is sanitized before commit.
