
resource "azurerm_service_plan" "service_plan" {
  name                = var.service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  sku_name            = var.sku_name
  os_type             = var.os_type
  tags = var.tags
}

resource "azurerm_function_app_flex_consumption" "app_flex_consumption" {
  name                        = var.app_flex_consumption_name
  resource_group_name         = var.resource_group_name
  location                    = var.resource_group_location
  service_plan_id             = azurerm_service_plan.service_plan.id
  storage_container_endpoint  = var.storage_container_endpoint
  storage_container_type      = var.storage_container_type
  storage_authentication_type = var.storage_authentication_type
  runtime_name                = var.runtime_name
  runtime_version             = var.runtime_version
  maximum_instance_count      = var.maximum_instance_count
  instance_memory_in_mb       = var.instance_memory_in_mb
  
  app_settings = var.app_settings
  storage_user_assigned_identity_id = var.storage_user_assigned_identity_id
  # storage_access_key = var.storage_access_key # Enable for storage access key

  identity {
    type         = var.identity_type
    identity_ids = var.identity_ids
  }

  site_config {
    application_insights_connection_string = var.app_insights_connection_string
  }

}

# Grant the function's system-assigned MI access to the Key Vault so App Service
# can resolve @Microsoft.KeyVault(...) app settings. Only created when the
# caller passes a keyvault_id and the function actually has a system identity
# (identity_type contains "SystemAssigned").
resource "azurerm_role_assignment" "kv_secrets_user_for_system_mi" {
  count                = var.keyvault_id == null ? 0 : 1
  scope                = var.keyvault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_function_app_flex_consumption.app_flex_consumption.identity[0].principal_id
}
