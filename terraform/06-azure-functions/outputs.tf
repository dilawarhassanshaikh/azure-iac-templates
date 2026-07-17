output "function_app_hostname" {
  description = "Default hostname of the function app."
  value       = azurerm_linux_function_app.this.default_hostname
}

output "function_app_id" {
  description = "Resource ID of the function app."
  value       = azurerm_linux_function_app.this.id
}
