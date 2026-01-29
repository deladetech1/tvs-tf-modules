output "postgresql_flexible_server_fqdn" {
  value = azurerm_postgresql_flexible_server.postgresql.fqdn
}

output "postgresql_flexible_server_id" {
  value = azurerm_postgresql_flexible_server.postgresql.id
}

output "postgresql_flexible_server_password" {
  value = azurerm_postgresql_flexible_server.postgresql.administrator_password
  sensitive = true
}

output "postgresql_flexible_server_username" {
    value = azurerm_postgresql_flexible_server.postgresql.administrator_login
}

output "postgresql_flexible_server_name" {
  value = azurerm_postgresql_flexible_server.postgresql.name
}