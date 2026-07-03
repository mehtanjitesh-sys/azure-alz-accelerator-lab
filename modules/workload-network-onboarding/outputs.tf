output "forced_egress_route_table_ids" {
  value = {
    for key, route_table in azurerm_route_table.forced_egress : key => route_table.id
  }
}

