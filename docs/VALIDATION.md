# Validation

## Static Validation

```bash
cd environments/alz-platform
terraform init
terraform fmt -recursive -check
terraform validate
terraform plan -detailed-exitcode -out=tfplan
```

## ALZ-Specific Validation

Confirm that:

- `.alzlib` is ignored and not committed.
- The `azure/alz` provider downloads the Microsoft ALZ library.
- `enterprise.alz_architecture_definition.yaml` is discovered.
- Management groups are created under the tenant root.
- Subscription placement maps the expected subscriptions to the expected management groups.
- Policy non-compliance messages are applied.

## Hub Egress Validation

```bash
az network firewall show \
  --resource-group rg-contoso-connectivity-hub \
  --name azfw-contoso-hub \
  --query "{name:name,privateIp:ipConfigurations[0].privateIPAddress}" \
  --output table

az network route-table route list \
  --resource-group <spoke-network-resource-group> \
  --route-table-name rt-<spoke-key>-forced-egress \
  --output table
```

Expected result:

- Route table contains `0.0.0.0/0`.
- Next hop type is `VirtualAppliance`.
- Next hop IP is the Azure Firewall private IP.
- Spoke subnets are associated with the forced-egress route table.
- Spoke internet traffic exits through the hub firewall.

## Subscription Vending Validation

```bash
az account management-group subscription show-sub-under-mg \
  --name contoso-regulated-prod

az role assignment list \
  --scope /subscriptions/<subscription-id> \
  --output table

az consumption budget list \
  --scope /subscriptions/<subscription-id> \
  --output table
```

Expected result:

- Subscription appears under the correct management group.
- Owner and reader groups are assigned.
- Budget exists.
- Activity log diagnostics point to the central workspace.

## Identity Validation

```bash
az ad app federated-credential list \
  --id <platform-deployer-app-id> \
  --output table

az role assignment list \
  --assignee <platform-deployer-object-id> \
  --all \
  --output table
```

Expected result:

- GitHub OIDC federated credential exists.
- No client secret is required.
- Deployment identity has only the required management-group permissions.

## Key Vault And Private Endpoint Validation

```bash
az keyvault show \
  --name <platform-key-vault-name> \
  --query "{name:name,rbac:properties.enableRbacAuthorization,purge:properties.enablePurgeProtection,publicNet:properties.publicNetworkAccess}" \
  --output table

az network private-endpoint list \
  --resource-group rg-contoso-platform-secrets \
  --output table

az role assignment list \
  --scope <key-vault-resource-id> \
  --output table
```

Expected result:

- RBAC authorization is enabled and purge protection is on.
- Public network access is `Disabled`; network ACL default action is `Deny`.
- A private endpoint exists for the vault (`vault` subresource) in the hub
  private-endpoints subnet, with a `privatelink.vaultcore.azure.net` zone linked
  to the hub VNet.
- Vault-scoped role assignments: platform admin group has *Key Vault
  Administrator*; the `platform_deployer` service principal has *Key Vault
  Secrets User*.
- Diagnostics point to the central Log Analytics workspace.

## Blue/Green Validation

```bash
az afd endpoint show \
  --profile-name afd-contoso-bluegreen \
  --resource-group rg-contoso-bluegreen-ref \
  --endpoint-name fde-contoso-bluegreen \
  --query hostName \
  --output tsv
```

Expected result:

- Front Door endpoint exists.
- Blue and green origins are in the same origin group.
- Traffic can be shifted by changing `blue_origin_weight` and `green_origin_weight`.
- Rollback is possible by returning weight to blue.
