data "azapi_client_config" "current" {}

locals {
  subscription_placement = {
    for key, subscription in var.subscriptions : key => {
      subscription_id       = subscription.subscription_id
      management_group_name = subscription.management_group_name
    }
  }
}

module "alz" {
  source  = "Azure/avm-ptn-alz/azurerm"
  version = "0.21.0"

  architecture_name  = "enterprise"
  location           = var.location
  parent_resource_id = data.azapi_client_config.current.tenant_id
  enable_telemetry   = false

  management_group_hierarchy_settings = {
    default_management_group_name            = "${var.enterprise_id}-sandbox"
    require_authorization_for_group_creation = true
  }

  subscription_placement = local.subscription_placement

  policy_assignment_non_compliance_message_settings = {
    default_message = "This resource must comply with the enterprise landing-zone control assigned at this scope."
    merge_mode      = "replace"
  }

  policy_assignments_to_modify = var.policy_assignments_to_modify
  policy_default_values        = var.policy_default_values

  management_group_role_assignments = var.management_group_role_assignments
}

module "hub_egress" {
  source = "../../modules/hub-egress"

  location                      = var.location
  prefix                        = var.enterprise_id
  resource_group_name           = "rg-${var.enterprise_id}-connectivity-hub"
  hub_vnet_address_space        = var.hub_vnet_address_space
  firewall_subnet_cidr          = var.firewall_subnet_cidr
  bastion_subnet_cidr           = var.bastion_subnet_cidr
  dns_inbound_subnet_cidr       = var.dns_inbound_subnet_cidr
  dns_outbound_subnet_cidr      = var.dns_outbound_subnet_cidr
  private_endpoints_subnet_cidr = var.private_endpoints_subnet_cidr
  spokes                        = var.spokes
  dns_forwarding_rules          = var.dns_forwarding_rules
  log_analytics_workspace_id    = var.log_analytics_workspace_id
  ddos_protection_plan_id       = var.ddos_protection_plan_id
  firewall_policy_sku           = var.firewall_policy_sku
  firewall_sku_tier             = var.firewall_sku_tier
}

module "identity_baseline" {
  source = "../../modules/identity-baseline"

  prefix                          = var.enterprise_id
  tenant_root_management_group_id = module.alz.management_group_resource_ids["${var.enterprise_id}-alz"]
  break_glass_user_object_ids     = var.break_glass_user_object_ids
  platform_admin_group_object_id  = var.platform_admin_group_object_id
  security_reader_group_object_id = var.security_reader_group_object_id
  github_repository_subjects      = var.github_repository_subjects
}

module "subscription_vending" {
  source = "../../modules/subscription-vending"

  subscriptions              = var.subscriptions
  default_tags               = var.default_tags
  log_analytics_workspace_id = var.log_analytics_workspace_id
}

module "workload_network_onboarding" {
  source = "../../modules/workload-network-onboarding"

  location                    = var.location
  hub_vnet_id                 = module.hub_egress.hub_vnet_id
  firewall_private_ip_address = module.hub_egress.firewall_private_ip_address
  spokes                      = var.spokes
}

module "platform_key_vault" {
  source = "../../modules/key-vault"

  prefix                          = var.enterprise_id
  name                            = var.platform_key_vault_name
  resource_group_name             = "rg-${var.enterprise_id}-platform-secrets"
  location                        = var.location
  log_analytics_workspace_id      = var.log_analytics_workspace_id
  private_endpoint_subnet_id      = module.hub_egress.private_endpoints_subnet_id
  private_endpoint_vnet_id        = module.hub_egress.hub_vnet_id
  key_vault_admin_group_object_id = var.platform_admin_group_object_id
  platform_deployer_principal_id  = module.identity_baseline.platform_deployer_object_id
  tags                            = var.default_tags
}

module "blue_green_frontdoor" {
  source = "../../modules/blue-green-frontdoor"

  enabled             = var.enable_blue_green_reference
  prefix              = var.enterprise_id
  location            = var.location
  resource_group_name = "rg-${var.enterprise_id}-bluegreen-ref"
  blue_origin_host    = var.blue_origin_host
  green_origin_host   = var.green_origin_host
  blue_origin_weight  = var.blue_origin_weight
  green_origin_weight = var.green_origin_weight
}
