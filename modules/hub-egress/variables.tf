variable "location" {
  type = string
}

variable "prefix" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "hub_vnet_address_space" {
  type = list(string)
}

variable "firewall_subnet_cidr" {
  type = string
}

variable "bastion_subnet_cidr" {
  type = string
}

variable "dns_inbound_subnet_cidr" {
  type = string
}

variable "dns_outbound_subnet_cidr" {
  type = string
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
  type = string
}

variable "spokes" {
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
