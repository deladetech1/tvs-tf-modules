resource "azurerm_api_management_api" "example" {
  name                = var.api_name
  resource_group_name = var.resource_group_name
  api_management_name = var.api_management_name
  revision            = var.revision
  display_name        = var.display_name
  path                = var.path
  protocols           = var.protocols

  service_url = var.service_url
}