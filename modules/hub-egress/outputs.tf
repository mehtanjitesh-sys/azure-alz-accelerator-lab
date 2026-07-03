output "hub_vnet_id" {
  value = azurerm_virtual_network.hub.id
}

output "firewall_private_ip_address" {
  value = azurerm_firewall.this.ip_configuration[0].private_ip_address
}

output "dns_resolver_inbound_endpoint_id" {
  value = azurerm_private_dns_resolver_inbound_endpoint.this.id
}
