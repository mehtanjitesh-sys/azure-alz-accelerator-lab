# PIM And Identity Notes

The Terraform in `modules/identity-baseline` intentionally avoids pretending that every identity control is universally deployable without tenant-specific licensing and approval.

## Implemented

- Federated GitHub deployment identity
- Service principal without client secret
- Platform admin group role assignment
- Security reader group role assignment
- Break-glass owner assignment

## Production Enhancements

For a real tenant, add:

- Microsoft Entra PIM eligible assignments for privileged Azure roles
- Conditional Access policies for admins
- Break-glass exclusions from risky Conditional Access controls
- Emergency access monitoring
- Access reviews
- Justification and approval requirements for privileged activation

## Interview Talking Point

Active role assignment is easy to demonstrate in Terraform. PIM is the better production control for privileged roles. I would use active assignment only for tightly controlled deployment identities and emergency access, then use PIM eligibility for human administrators.

