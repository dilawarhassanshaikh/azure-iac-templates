output "lb_public_ip" {
  description = "Public IP address of the load balancer frontend."
  value       = azurerm_public_ip.this.ip_address
}

output "lb_id" {
  description = "Resource ID of the load balancer."
  value       = azurerm_lb.this.id
}
