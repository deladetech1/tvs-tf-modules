output "redis_id" {
  value = azurerm_redis_cache.redis.id
}

output "redis_primary_connection_string" {
  value = azurerm_redis_cache.redis.primary_connection_string
  sensitive = true
}

output "redis_primary_access_key" {
  value = azurerm_redis_cache.redis.primary_access_key
  sensitive = true
}

output "redis_server_hostname" {
  value = azurerm_redis_cache.redis.hostname
}