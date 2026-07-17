output "frontdoor_endpoint_hostname" {
  description = "Hostname of the Front Door endpoint."
  value       = azurerm_cdn_frontdoor_endpoint.this.host_name
}
