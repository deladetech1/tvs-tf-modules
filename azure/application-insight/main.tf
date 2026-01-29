resource "azurerm_application_insights" "app-insight" {
  name                = var.insight_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  workspace_id        = var.workspace_id
  application_type    = var.application_type
  tags = var.tags
}
