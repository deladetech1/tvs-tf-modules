
output "queue_name" {
  value = azurerm_storage_queue.storage_queue.name
}

output "queue_id" {
  value = azurerm_storage_queue.storage_queue.id
}

output "queue_metadata" {
  value = azurerm_storage_queue.storage_queue.metadata
}