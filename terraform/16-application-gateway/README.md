# 16 - Application Gateway

Deploys an Application Gateway v2 (WAF_v2 by default) in its own dedicated
virtual network/subnet, with a static Standard public IP, autoscaling, a
backend pool (placeholder IPs), an HTTP listener, and a basic routing rule.

## Architecture

![Contoso Ltd. sample architecture — Application Gateway](../../docs/diagrams/16-application-gateway.svg)

## Resources created

- `azurerm_resource_group`
- `azurerm_virtual_network` + `azurerm_subnet` (dedicated `appgw-subnet`)
- `azurerm_public_ip` (Standard, static)
- `azurerm_application_gateway` (WAF_v2, autoscale 1-3, HTTP listener + basic routing rule)

## Required inputs

| Name | Description | Default |
|------|-------------|---------|
| `name_prefix` | Prefix for resource names | `iacagw` |
| `location` | Azure region | `eastus` |
| `sku_name` | Gateway SKU/tier | `WAF_v2` |
| `autoscale_min_capacity` | Min autoscale instances | `1` |
| `autoscale_max_capacity` | Max autoscale instances | `3` |
| `backend_ip_addresses` | Placeholder backend pool IPs; replace with real targets | `["10.1.2.4"]` |
| `tags` | Resource tags | see `variables.tf` |

No inputs are required beyond the defaults; this module deploys standalone,
though the `backend_ip_addresses` placeholder should be updated to point at
real backend targets before serving production traffic.

## Usage

```bash
cd terraform/16-application-gateway
terraform init
terraform apply -var-file=terraform.tfvars.example
```
