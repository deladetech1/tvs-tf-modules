output "access_key" {
  value = azurerm_storage_account.storage-account.primary_access_key
  sensitive = true
}

output "name" {
  value = azurerm_storage_account.storage-account.name
  sensitive = false
}

output "storage_id" {
  value = azurerm_storage_account.storage-account.id
}

output "primary_connection_string" {
  value = azurerm_storage_account.storage-account.primary_connection_string
  sensitive = true
}

output "table_endpoint" {
  value = azurerm_storage_account.storage-account.primary_table_endpoint
}

output "blob_endpoint" {
  value = azurerm_storage_account.storage-account.primary_blob_endpoint
}

output "queue_endpoint" {
  value = azurerm_storage_account.storage-account.primary_queue_endpoint
}