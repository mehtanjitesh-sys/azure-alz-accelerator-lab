variable "location" {
  type    = string
  default = "eastus"
}

variable "enterprise_id" {
  type        = string
  description = "Enterprise identifier used in management group and resource names. Must match the IDs in lib/enterprise.alz_architecture_definition.yaml."
  default     = "contoso"

  validation {
    condition     = var.enterprise_id == "contoso"
    error_message = "This lab architecture file is currently pinned to the contoso enterprise_id. Generate a matching ALZ architecture file before changing this value."
  }
}

variable "platform_subscription_id" {
  type        = string
  description = "Subscription used for platform services such as connectivity, management, and identity."
}

variable "subscriptions" {
  description = "Subscription vending and placement map."
  type = map(object({
    subscription_id       = string
    management_group_name = string
    display_name          = string
    environment           = string
    business_unit         = string
    cost_center           = string
    data_classification   = string
    monthly_budget        = number
    billing_scope_id      = optional(string)
    owner_group_object_id = string
    reader_group_object_id = optional(string)
    connectivity          = string
    workload_vnet_id      = optional(string)
    workload_route_table_ids = optional(list(string), [])
    tags                  = optional(map(string), {})
  }))
}

variable "spokes" {
  description = "Existing spoke VNets that must be peered to the hub and forced through firewall egress."
  type = map(object({
    vnet_id        = string
    vnet_name      = string
    resource_group = string
    subnet_ids     = list(string)
  }))
  default = {}
}

variable "dns_forwarding_rules" {
  type = map(object({
    domain_name = string
    target_dns_servers = list(object({
      ip_address = string
      port       = optional(number, 53)
    }))
  }))
  default = {}
}

variable "hub_vnet_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "firewall_subnet_cidr" {
  type    = string
  default = "10.0.0.0/26"
}

variable "bastion_subnet_cidr" {
  type    = string
  default = "10.0.0.64/26"
}

variable "dns_inbound_subnet_cidr" {
  type    = string
  default = "10.0.1.0/28"
}

variable "dns_outbound_subnet_cidr" {
  type    = string
  default = "10.0.1.16/28"
}

variable "ddos_protection_plan_id" {
  type    = string
  default = null
}

variable "firewall_policy_sku" {
  type    = string
  default = "Standard"
}

variable "firewall_sku_tier" {
  type    = string
  default = "Standard"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Central Log Analytics workspace resource ID."
}

variable "default_tags" {
  type    = map(string)
  default = {}
}

variable "policy_assignments_to_modify" {
  type    = any
  default = {}
}

variable "policy_default_values" {
  type    = map(string)
  default = null
}

variable "management_group_role_assignments" {
  type    = any
  default = {}
}

variable "break_glass_user_object_ids" {
  type    = set(string)
  default = []
}

variable "platform_admin_group_object_id" {
  type = string
}

variable "security_reader_group_object_id" {
  type = string
}

variable "github_repository_subjects" {
  description = "GitHub OIDC subjects allowed to deploy the platform."
  type        = set(string)
  default     = []
}

variable "enable_blue_green_reference" {
  type    = bool
  default = true
}

variable "blue_origin_host" {
  type    = string
  default = "blue.example.com"
}

variable "green_origin_host" {
  type    = string
  default = "green.example.com"
}

variable "blue_origin_weight" {
  type        = number
  description = "Front Door origin weight for the blue/live origin."
  default     = 1000
}

variable "green_origin_weight" {
  type        = number
  description = "Front Door origin weight for the green/staging origin."
  default     = 0
}
