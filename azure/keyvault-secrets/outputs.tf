# Versionless id so ACA / function Key Vault references always resolve to the
# LATEST secret version (the versioned id pins consumers to one version, forcing
# a re-apply of the app whenever the secret value changes).
output "secret_id" {
  value = azurerm_key_vault_secret.keyvault-secret.versionless_id
}

# Kept available for anything that genuinely needs the pinned version.
output "versioned_secret_id" {
  value = azurerm_key_vault_secret.keyvault-secret.id
}