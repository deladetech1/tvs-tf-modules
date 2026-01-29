resource "azurerm_container_app_environment" "cae" {
  name                       = var.cae_name
  location                   = var.resource_group_location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = var.log_analytics_workspace_id
  
  workload_profile {
    name                  = var.workload_profile_name
    workload_profile_type = var.workload_profile_type
  }

  tags = var.tags
}