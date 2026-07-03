resource "azurerm_resource_group" "this" {
  count = var.enabled ? 1 : 0

  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_cdn_frontdoor_profile" "this" {
  count = var.enabled ? 1 : 0

  name                = "afd-${var.prefix}-bluegreen"
  resource_group_name = azurerm_resource_group.this[0].name
  sku_name            = "Standard_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_endpoint" "this" {
  count = var.enabled ? 1 : 0

  name                     = "fde-${var.prefix}-bluegreen"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this[0].id
}

resource "azurerm_cdn_frontdoor_origin_group" "live" {
  count = var.enabled ? 1 : 0

  name                     = "live-bluegreen"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this[0].id

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }

  health_probe {
    interval_in_seconds = 100
    path                = "/health"
    protocol            = "Https"
    request_type        = "GET"
  }
}

resource "azurerm_cdn_frontdoor_origin" "blue" {
  count = var.enabled ? 1 : 0

  name                          = "blue-live-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.live[0].id
  host_name                     = var.blue_origin_host
  origin_host_header            = var.blue_origin_host
  http_port                     = 80
  https_port                    = 443
  priority                      = 1
  weight                        = var.blue_origin_weight
  certificate_name_check_enabled = true
}

resource "azurerm_cdn_frontdoor_origin" "green" {
  count = var.enabled ? 1 : 0

  name                          = "green-staging-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.live[0].id
  host_name                     = var.green_origin_host
  origin_host_header            = var.green_origin_host
  http_port                     = 80
  https_port                    = 443
  priority                      = 1
  weight                        = var.green_origin_weight
  certificate_name_check_enabled = true
}

resource "azurerm_cdn_frontdoor_route" "live" {
  count = var.enabled ? 1 : 0

  name                          = "route-live"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.this[0].id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.live[0].id
  cdn_frontdoor_origin_ids      = [
    azurerm_cdn_frontdoor_origin.blue[0].id,
    azurerm_cdn_frontdoor_origin.green[0].id
  ]
  supported_protocols           = ["Http", "Https"]
  patterns_to_match             = ["/*"]
  forwarding_protocol           = "HttpsOnly"
  https_redirect_enabled        = true
  link_to_default_domain        = true
}
