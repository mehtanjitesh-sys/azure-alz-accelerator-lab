# ALZ Custom Library

This directory is loaded by the `azure/alz` provider alongside the Microsoft `platform/alz` library.

## What Is Custom Here

- `enterprise.alz_architecture_definition.yaml` defines the management group hierarchy used by this lab.
- `alz_library_metadata.json` identifies this folder as a local ALZ library.

## What Comes From Microsoft's ALZ Library

The archetypes referenced by the architecture definition, such as `root`, `platform`, `connectivity`, `identity`, `management`, `landing_zones`, `corp`, `online`, `sandbox`, and `decommissioned`, are intentionally sourced from the Microsoft `platform/alz` library reference configured in `environments/alz-platform/providers.tf`.

## Prefix Note

The current architecture definition is pinned to the `contoso-*` management group IDs. If `enterprise_id` is changed, generate a matching architecture definition before planning.
