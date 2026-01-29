output "system_assigned_principal_id" {
  value       = try(azurerm_function_app_flex_consumption.app_flex_consumption.identity[0].principal_id, null)
  description = "Principal ID for system-assigned managed identity"
}