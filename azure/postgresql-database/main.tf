resource "azurerm_postgresql_flexible_server_database" "database" {
  name      = var.db_name
  server_id = var.postgresql_server_id
  collation = "en_US.utf8"
  charset   = "UTF8"

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}