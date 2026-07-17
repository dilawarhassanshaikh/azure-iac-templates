output "vm_id" {
  description = "Resource ID of the Linux virtual machine."
  value       = azurerm_linux_virtual_machine.this.id
}

output "public_ip_address" {
  description = "Public IP address assigned to the VM."
  value       = azurerm_public_ip.this.ip_address
}

output "admin_username" {
  description = "Administrator username configured on the VM."
  value       = azurerm_linux_virtual_machine.this.admin_username
}
