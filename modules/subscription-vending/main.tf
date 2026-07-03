locals {
  owner_role_id  = "b24988ac-6180-42a0-ab88-20f7382dd24c" # Contributor
  reader_role_id = "acdd72a7-3385-48ef-bd42-f606fba81ae7" # Reader

  subscription_tags = {
    for key, subscription in var.subscriptions : key => merge(
      var.default_tags,
      subscription.tags,
      {
        environment         = subscription.environment
        business_unit       = subscription.business_unit
        cost_center         = subscription.cost_center
        data_classification = subscription.data_classification
        connectivity        = subscription.connectivity
        landing_zone        = subscription.management_group_name
      }
    )
  }
}

resource "azurerm_subscription" "alias" {
  for_each = {
    for key, subscription in var.subscriptions : key => subscription
    if try(subscription.billing_scope_id, null) != null
  }

  subscription_name = each.value.display_name
  billing_scope_id  = each.value.billing_scope_id
  alias             = each.key
  workload          = each.value.environment == "prod" ? "Production" : "DevTest"
  tags              = local.subscription_tags[each.key]
}

resource "azurerm_role_assignment" "workload_owner" {
  for_each = var.subscriptions

  scope                = "/subscriptions/${each.value.subscription_id}"
  role_definition_id   = "/subscriptions/${each.value.subscription_id}/providers/Microsoft.Authorization/roleDefinitions/${local.owner_role_id}"
  principal_id         = each.value.owner_group_object_id
  principal_type       = "Group"
}

resource "azurerm_role_assignment" "workload_reader" {
  for_each = {
    for key, subscription in var.subscriptions : key => subscription
    if subscription.reader_group_object_id != null
  }

  scope                = "/subscriptions/${each.value.subscription_id}"
  role_definition_id   = "/subscriptions/${each.value.subscription_id}/providers/Microsoft.Authorization/roleDefinitions/${local.reader_role_id}"
  principal_id         = each.value.reader_group_object_id
  principal_type       = "Group"
}

resource "azurerm_consumption_budget_subscription" "monthly" {
  for_each = var.subscriptions

  name            = "budget-${each.key}-monthly"
  subscription_id = each.value.subscription_id
  amount          = each.value.monthly_budget
  time_grain      = "Monthly"

  time_period {
    start_date = "2026-01-01T00:00:00Z"
  }

  notification {
    enabled        = true
    threshold      = 80
    operator       = "GreaterThan"
    threshold_type = "Actual"
    contact_groups = []
  }

  notification {
    enabled        = true
    threshold      = 100
    operator       = "GreaterThan"
    threshold_type = "Forecasted"
    contact_groups = []
  }
}

resource "azurerm_monitor_diagnostic_setting" "subscription_activity" {
  for_each = var.subscriptions

  name                       = "diag-${each.key}-activity"
  target_resource_id         = "/subscriptions/${each.value.subscription_id}"
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "Administrative"
  }

  enabled_log {
    category = "Security"
  }

  enabled_log {
    category = "Policy"
  }
}
