resource "azurerm_role_assignment" "mi_roles" {
  for_each = var.role_assignments
  role_definition_name = each.value.role_definition_name
  principal_id = var.managed_identity_principal_id
  scope = each.value.scope
}