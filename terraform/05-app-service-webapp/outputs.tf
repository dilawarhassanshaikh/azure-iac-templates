output "default_hostname" {
  description = "Default hostname of the web app (*.azurewebsites.net)."
  value       = azurerm_linux_web_app.this.default_hostname
}

output "app_id" {
  description = "Resource ID of the web app."
  value       = azurerm_linux_web_app.this.id
}
