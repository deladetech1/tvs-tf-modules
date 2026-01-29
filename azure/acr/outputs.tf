output "resource_group_name" {
  value       = var.resource_group_name
}

output "resource_group_location" {
  value       = var.resource_group_location
}

output "acr_name" {
  value       = azurerm_container_registry.acr.name
}

output "acr_url" {
  value       = azurerm_container_registry.acr.login_server
}

output "acr_id" {
  value       = azurerm_container_registry.acr.id
}

output "login_server" {
  value = azurerm_container_registry.acr.login_server
}