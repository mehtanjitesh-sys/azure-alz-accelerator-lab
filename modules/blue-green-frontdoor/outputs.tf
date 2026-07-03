output "endpoint_host_name" {
  value = var.enabled ? azurerm_cdn_frontdoor_endpoint.this[0].host_name : null
}

