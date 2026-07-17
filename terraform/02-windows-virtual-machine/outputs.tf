output "vm_id" {
  description = "Resource ID of the Windows virtual machine."
  value       = azurerm_windows_virtual_machine.this.id
}

output "public_ip_address" {
  description = "Public IP address assigned to the VM."
  value       = azurerm_public_ip.this.ip_address
}
