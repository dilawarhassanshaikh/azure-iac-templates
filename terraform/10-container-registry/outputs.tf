output "login_server" {
  description = "Login server hostname for the registry."
  value       = azurerm_container_registry.this.login_server
}

output "acr_id" {
  description = "Resource ID of the container registry."
  value       = azurerm_container_registry.this.id
}
