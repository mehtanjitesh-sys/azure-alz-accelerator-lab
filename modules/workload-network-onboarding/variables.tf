variable "location" {
  type = string
}

variable "hub_vnet_id" {
  type = string
}

variable "firewall_private_ip_address" {
  type = string
}

variable "spokes" {
  description = "Existing spoke VNets and subnets that should be attached to hub-controlled egress."
  type = map(object({
    vnet_id        = string
    vnet_name      = string
    resource_group = string
    subnet_ids     = list(string)
  }))
  default = {}
}

