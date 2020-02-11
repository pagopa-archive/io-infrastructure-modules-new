output "name" {
  value = azurerm_redis_cache.redis_cache.name
}

output "access_key" {
  value = azurerm_redis_cache.redis_cache.primary_access_key
}