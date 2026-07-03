output "management_group_resource_ids" {
  value = module.alz.management_group_resource_ids
}

output "hub_vnet_id" {
  value = module.hub_egress.hub_vnet_id
}

output "firewall_private_ip_address" {
  value = module.hub_egress.firewall_private_ip_address
}

output "blue_green_frontdoor_endpoint" {
  value = module.blue_green_frontdoor.endpoint_host_name
}

