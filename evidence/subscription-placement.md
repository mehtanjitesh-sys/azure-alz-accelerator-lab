# Subscription Placement Evidence

Paste sanitized output here after subscription placement.

Recommended commands:

```bash
az account management-group subscription show-sub-under-mg --name contoso-regulated-prod
az role assignment list --scope /subscriptions/<subscription-id> --output table
az consumption budget list --scope /subscriptions/<subscription-id> --output table
```

