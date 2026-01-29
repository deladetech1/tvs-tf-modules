resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled
  tags = var.tags
  public_network_access_enabled = var.public_network_access_enabled
}