
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

locals {
  system_principal_id = azurerm_function_app_flex_consumption.app_flex_consumption.identity[0].principal_id

  # Each entry creates one azurerm_role_assignment when the corresponding *_id
  # variable is non-null. Keys are arbitrary stable strings used for the for_each.
  system_mi_role_grants = merge(
    var.keyvault_id == null ? {} : {
      kv_secrets_user = {
        scope = var.keyvault_id
        role  = "Key Vault Secrets User"
      }
    },
    var.app_data_storage_id == null ? {} : {
      app_data_blob_contributor  = { scope = var.app_data_storage_id, role = "Storage Blob Data Contributor" }
      app_data_queue_contributor = { scope = var.app_data_storage_id, role = "Storage Queue Data Contributor" }
      app_data_table_contributor = { scope = var.app_data_storage_id, role = "Storage Table Data Contributor" }
    },
    var.function_deployment_storage_id == null ? {} : {
      fds_blob_owner = {
        scope = var.function_deployment_storage_id
        role  = "Storage Blob Data Owner"
      }
    },
    var.app_insight_id == null ? {} : {
      ai_metrics_publisher = {
        scope = var.app_insight_id
        role  = "Monitoring Metrics Publisher"
      }
    },
  )
}

resource "azurerm_role_assignment" "system_mi_grants" {
  for_each             = local.system_mi_role_grants
  scope                = each.value.scope
  role_definition_name = each.value.role
  principal_id         = local.system_principal_id
}
