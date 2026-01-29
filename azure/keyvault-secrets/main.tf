resource "azurerm_key_vault_secret" "keyvault-secret" {
  name         = var.secret_name
  value        = var.secret_value
  key_vault_id = var.keyvault_id
}