# Blue/Green Evidence

Paste sanitized output here after Front Door deployment.

Recommended commands:

```bash
az afd endpoint show --profile-name afd-contoso-bluegreen --resource-group rg-contoso-bluegreen-ref --endpoint-name fde-contoso-bluegreen --query hostName --output tsv
az afd origin list --profile-name afd-contoso-bluegreen --resource-group rg-contoso-bluegreen-ref --origin-group-name live-bluegreen --output table
```

