output "lb_public_ip" {
  description = "Public IP address of the load balancer fronting the scale set."
  value       = azurerm_public_ip.this.ip_address
}

output "vmss_id" {
  description = "Resource ID of the virtual machine scale set."
  value       = azurerm_linux_virtual_machine_scale_set.this.id
}
