variable "subscriptions" {
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

variable "default_tags" {
  type    = map(string)
  default = {}
}

variable "log_analytics_workspace_id" {
  type = string
}
