output "azurerm_redis_cache_name" {
  value = azurerm_redis_cache.redis_cache.name
}

output "azurerm_redis_cache_access_key" {
  value = azurerm_redis_cache.redis_cache.primary_access_key
}