# Hub Egress Evidence

Paste sanitized output here after connectivity deployment.

Recommended commands:

```bash
az network firewall show --resource-group rg-contoso-connectivity-hub --name azfw-contoso-hub --output table
az network route-table route list --resource-group <spoke-rg> --route-table-name rt-<spoke-key>-forced-egress --output table
az network vnet peering list --resource-group rg-contoso-connectivity-hub --vnet-name vnet-contoso-hub --output table
```
