resource "azurerm_storage_container" "storage-container" {
  name                  = var.container_name
  container_access_type = var.container_access_type
  storage_account_name = var.storage_account_name
}
