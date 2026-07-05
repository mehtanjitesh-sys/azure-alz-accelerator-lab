output "hub_vnet_id" {
  value = azurerm_virtual_network.hub.id
}

output "hub_vnet_name" {
  value = azurerm_virtual_network.hub.name
}

output "hub_resource_group_name" {
  value = azurerm_resource_group.this.name
}

output "private_endpoints_subnet_id" {
  value = azurerm_subnet.private_endpoints.id
}

output "firewall_private_ip_address" {
  value = azurerm_firewall.this.ip_configuration[0].private_ip_address
}

output "dns_resolver_inbound_endpoint_id" {
  value = azurerm_private_dns_resolver_inbound_endpoint.this.id
}
