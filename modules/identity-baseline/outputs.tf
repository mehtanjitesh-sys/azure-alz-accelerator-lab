output "platform_deployer_client_id" {
  value = azuread_application.platform_deployer.client_id
}

output "platform_deployer_object_id" {
  value = azuread_service_principal.platform_deployer.object_id
}

