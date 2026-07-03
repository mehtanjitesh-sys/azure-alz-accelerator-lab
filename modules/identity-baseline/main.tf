resource "azuread_application" "platform_deployer" {
  display_name = "app-${var.prefix}-platform-deployer"
}

resource "azuread_service_principal" "platform_deployer" {
  client_id = azuread_application.platform_deployer.client_id
}

resource "azuread_application_federated_identity_credential" "github" {
  for_each = var.github_repository_subjects

  application_id = azuread_application.platform_deployer.id
  display_name   = "github-${substr(sha1(each.value), 0, 12)}"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = each.value
}

resource "azurerm_role_assignment" "platform_deployer_reader" {
  scope                = var.tenant_root_management_group_id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.platform_deployer.object_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "platform_admin" {
  scope                = var.tenant_root_management_group_id
  role_definition_name = "Owner"
  principal_id         = var.platform_admin_group_object_id
  principal_type       = "Group"
}

resource "azurerm_role_assignment" "security_reader" {
  scope                = var.tenant_root_management_group_id
  role_definition_name = "Security Reader"
  principal_id         = var.security_reader_group_object_id
  principal_type       = "Group"
}

resource "azurerm_role_assignment" "break_glass_owner" {
  for_each = var.break_glass_user_object_ids

  scope                = var.tenant_root_management_group_id
  role_definition_name = "Owner"
  principal_id         = each.value
  principal_type       = "User"
}

