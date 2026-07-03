resource "azurerm_route_table" "forced_egress" {
  for_each = var.spokes

  name                = "rt-${each.key}-forced-egress"
  location            = var.location
  resource_group_name = each.value.resource_group

  route {
    name                   = "default-to-hub-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.firewall_private_ip_address
  }
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  for_each = var.spokes

  name                         = "peer-${each.key}-to-hub"
  resource_group_name          = each.value.resource_group
  virtual_network_name         = each.value.vnet_name
  remote_virtual_network_id    = var.hub_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = false
}

resource "azurerm_subnet_route_table_association" "forced_egress" {
  for_each = {
    for item in flatten([
      for spoke_key, spoke in var.spokes : [
        for subnet_id in spoke.subnet_ids : {
          key       = "${spoke_key}-${sha1(subnet_id)}"
          spoke_key = spoke_key
          subnet_id = subnet_id
        }
      ]
    ]) : item.key => item
  }

  subnet_id      = each.value.subnet_id
  route_table_id = azurerm_route_table.forced_egress[each.value.spoke_key].id
}

