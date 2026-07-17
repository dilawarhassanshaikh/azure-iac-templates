output "namespace_id" {
  description = "Resource ID of the Service Bus namespace."
  value       = azurerm_servicebus_namespace.this.id
}

output "primary_connection_string" {
  description = "Primary connection string for the Service Bus namespace."
  value       = azurerm_servicebus_namespace.this.default_primary_connection_string
  sensitive   = true
}

output "queue_name" {
  description = "Name of the Service Bus queue."
  value       = azurerm_servicebus_queue.this.name
}
