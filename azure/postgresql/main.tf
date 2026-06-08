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

# "Allow public access from any Azure service" (0.0.0.0). Lets Azure-hosted
# runners create per-app roles via the postgresql provider. Restrict to specific
# ranges in prod via var.allowed_ip_ranges instead.
resource "azurerm_postgresql_flexible_server_firewall_rule" "azure_services" {
  count            = var.allow_azure_services ? 1 : 0
  name             = "AllowAzureServices"
  server_id        = azurerm_postgresql_flexible_server.postgresql.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "ranges" {
  for_each         = var.allowed_ip_ranges
  name             = each.key
  server_id        = azurerm_postgresql_flexible_server.postgresql.id
  start_ip_address = each.value.start_ip
  end_ip_address   = each.value.end_ip
}
