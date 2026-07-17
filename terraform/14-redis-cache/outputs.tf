output "hostname" {
  description = "Hostname of the Redis cache."
  value       = azurerm_redis_cache.this.hostname
}

output "ssl_port" {
  description = "SSL port used to connect to the Redis cache."
  value       = azurerm_redis_cache.this.ssl_port
}

output "primary_access_key" {
  description = "Primary access key for the Redis cache."
  value       = azurerm_redis_cache.this.primary_access_key
  sensitive   = true
}
