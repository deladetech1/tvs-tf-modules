output "system_assigned_principal_id" {
  description = "Principal ID of the container app's system-assigned identity (null when not enabled). Grant this Key Vault Secrets User so KV reference secrets resolve."
  value       = var.enable_system_assigned_identity ? azurerm_container_app.containerapp.identity[0].principal_id : null
}

output "container_app_name" {
  value = azurerm_container_app.containerapp.name
}

output "container_app_fqdn" {
  value = try(azurerm_container_app.containerapp.ingress[0].fqdn, null)
}
