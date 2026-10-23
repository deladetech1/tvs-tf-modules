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

  # When Azure may patch the server. Without it ("customWindow: Disabled") Azure
  # picks any time, and a patch refuses connections for minutes -- tvs-shared-sql
  # went down mid-day on 2026-10-23 that way. null = leave Azure's own schedule.
  dynamic "maintenance_window" {
    for_each = var.maintenance_window == null ? [] : [var.maintenance_window]
    content {
      day_of_week  = maintenance_window.value.day_of_week
      start_hour   = maintenance_window.value.start_hour
      start_minute = maintenance_window.value.start_minute
    }
  }

  # A hot standby (General Purpose / Memory Optimized only). null = none.
  dynamic "high_availability" {
    for_each = var.high_availability_mode == null ? [] : [var.high_availability_mode]
    content {
      mode                      = high_availability.value
      standby_availability_zone = high_availability.value == "ZoneRedundant" ? var.standby_availability_zone : null
    }
  }
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
