resource "azurerm_user_assigned_identity" "mi" {
  name                = var.mi_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  tags = var.tags
}