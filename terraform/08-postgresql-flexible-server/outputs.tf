output "server_fqdn" {
  description = "Fully qualified domain name of the PostgreSQL flexible server."
  value       = azurerm_postgresql_flexible_server.this.fqdn
}

output "database_id" {
  description = "Resource ID of the PostgreSQL database."
  value       = azurerm_postgresql_flexible_server_database.this.id
}
