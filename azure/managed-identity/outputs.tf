output "mi_client_id" {
  value = azurerm_user_assigned_identity.mi.client_id
}

output "mi_id" {
  value = azurerm_user_assigned_identity.mi.id
}

output "mi_principal_id" {
  value = azurerm_user_assigned_identity.mi.principal_id
}

output "mi_tenant_id" {
  value = azurerm_user_assigned_identity.mi.tenant_id
}