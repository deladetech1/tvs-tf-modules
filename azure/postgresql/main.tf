resource "azurerm_postgresql_flexible_server" "postgresql" {
  name                    = var.postgresql_server_name
  resource_group_name     = var.resource_group_name
  location                = var.resource_group_location
  version                 = var.postgresql_version
  administrator_login     = var.postgresql_admin_username
  administrator_password  = var.postgresql_admin_password
  storage_mb              = var.postgresql_storage_mb
  sku_name                = var.postgresql_sku_name
  storage_tier            = var.storage_tier
  public_network_access_enabled = var.public_network_access_enabled
  zone = var.postgresql_zone
  auto_grow_enabled = var.auto_grow_enabled
  tags = var.tags
}
