output "keyvault_id" {
  value = azurerm_key_vault.key_vault.id
}

output "keyvault_uri" {
  value = azurerm_key_vault.key_vault.vault_uri
}

output "subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}