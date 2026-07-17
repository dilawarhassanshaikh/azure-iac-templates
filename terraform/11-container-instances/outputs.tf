output "fqdn" {
  description = "Fully qualified domain name of the container group's public IP."
  value       = azurerm_container_group.this.fqdn
}

output "ip_address" {
  description = "Public IP address of the container group."
  value       = azurerm_container_group.this.ip_address
}
