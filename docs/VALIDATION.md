# Validation

## Static Validation

```bash
cd environments/alz-platform
terraform init
terraform fmt -recursive -check
terraform validate
terraform plan -out=tfplan
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
  --resource-group rg-contoso-connectivity-hub \
  --route-table-name rt-contoso-spoke-egress \
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
- Blue origin is live.
- Green origin can be validated before traffic switch.
- Rollback is possible by returning traffic to blue.

