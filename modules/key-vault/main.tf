data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_key_vault" "this" {
  name                = var.name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.sku_name

  enable_rbac_authorization     = true
  purge_protection_enabled      = true
  soft_delete_retention_days    = var.soft_delete_retention_days
  public_network_access_enabled = false

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "diag-kv-${var.prefix}"
  target_resource_id         = azurerm_key_vault.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category_group = "allLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

module "private_endpoint" {
  source = "../private-endpoint"

  name_prefix                  = "${var.prefix}-kv"
  target_resource_id           = azurerm_key_vault.this.id
  subresource_names            = ["vault"]
  subnet_id                    = var.private_endpoint_subnet_id
  vnet_id                      = var.private_endpoint_vnet_id
  resource_group_name          = azurerm_resource_group.this.name
  location                     = azurerm_resource_group.this.location
  private_dns_zone_name        = var.private_dns_zone_name
  create_private_dns_zone      = var.create_private_dns_zone
  existing_private_dns_zone_id = var.existing_private_dns_zone_id
  tags                         = var.tags
}

resource "azurerm_role_assignment" "kv_administrator" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = var.key_vault_admin_group_object_id
  principal_type       = "Group"
}

resource "azurerm_role_assignment" "deployer_secrets_user" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.platform_deployer_principal_id
  principal_type       = "ServicePrincipal"
}
