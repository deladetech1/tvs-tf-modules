data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "key_vault" {
  name                        = var.key_vault_name
  location                    = var.resource_group_location
  resource_group_name         = var.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = var.sku_name
  purge_protection_enabled    = var.purge_protection_enabled
  soft_delete_retention_days  = var.soft_delete_retention_days
  enable_rbac_authorization = var.enable_rbac_authorization
  network_acls {
    default_action = var.default_action
    bypass         = var.bypass
  }

  tags = var.tags
}

resource "azurerm_role_assignment" "mi_roles" {
  role_definition_name = "Key Vault Administrator"
  principal_id = data.azurerm_client_config.current.object_id
  scope = azurerm_key_vault.key_vault.id
}