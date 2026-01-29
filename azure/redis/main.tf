# NOTE: the Name used for Redis needs to be globally unique
resource "azurerm_redis_cache" "redis" {
  name                = var.redis_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  capacity             = var.capacity
  family               = var.redis_family
  sku_name             = var.sku_name
  non_ssl_port_enabled = var.non_ssl_port_enabled
  minimum_tls_version  = var.minimum_tls_version
  public_network_access_enabled = var.public_network_access_enabled

  identity {
    type = "SystemAssigned"
  }
}