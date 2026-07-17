# 15 - Load Balancer

Deploys a Standard public Load Balancer with a static public IP, a backend
address pool, a TCP health probe, and an LB rule forwarding port 80 to the
backend pool on port 80.

## Architecture

![Contoso Ltd. sample architecture — Load Balancer](../../docs/diagrams/15-load-balancer.svg)

## Resources created

- `azurerm_resource_group`
- `azurerm_public_ip` (Standard, static)
- `azurerm_lb` (Standard)
- `azurerm_lb_backend_address_pool`
- `azurerm_lb_probe` (TCP, configurable port)
- `azurerm_lb_rule` (80 -> 80)

## Required inputs

| Name | Description | Default |
|------|-------------|---------|
| `name_prefix` | Prefix for resource names | `iaclb` |
| `location` | Azure region | `eastus` |
| `health_probe_port` | TCP port for the health probe | `80` |
| `tags` | Resource tags | see `variables.tf` |

No inputs are required beyond the defaults; this module deploys standalone.
Attach VMs or a VMSS to the `azurerm_lb_backend_address_pool` created here to
receive traffic.

## Usage

```bash
cd terraform/15-load-balancer
terraform init
terraform apply -var-file=terraform.tfvars.example
```
