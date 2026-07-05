output "key_vault_id" {
  value = azurerm_key_vault.this.id
}

output "key_vault_uri" {
  value = azurerm_key_vault.this.vault_uri
}

output "resource_group_name" {
  value = azurerm_resource_group.this.name
}

output "private_endpoint_id" {
  value = module.private_endpoint.private_endpoint_id
}

output "private_endpoint_ip_address" {
  value = module.private_endpoint.private_ip_address
}
