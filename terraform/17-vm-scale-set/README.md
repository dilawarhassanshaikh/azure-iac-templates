# 17 - VM Scale Set

Deploys a Linux Virtual Machine Scale Set (Ubuntu 22.04, SSH-key auth only,
Manual upgrade mode) in a dedicated virtual network/subnet, fronted by a
Standard Load Balancer with a health probe and an inbound NAT pool for
per-instance SSH access.

## Architecture

![Contoso Ltd. sample architecture — VM Scale Set](../../docs/diagrams/17-vm-scale-set.svg)

## Resources created

- `azurerm_resource_group`
- `azurerm_virtual_network` + `azurerm_subnet`
- `azurerm_public_ip` (Standard, static)
- `azurerm_lb` (Standard) + backend address pool + TCP health probe (port 80) + LB rule (80->80)
- `azurerm_lb_nat_pool` (ports 50000-50019 -> 22)
- `azurerm_linux_virtual_machine_scale_set` (Ubuntu 22.04, SSH key auth, attached to LB backend pool and NAT pool)

## Required inputs

| Name | Description | Default |
|------|-------------|---------|
| `ssh_public_key` | SSH public key for `admin_username`. No default. | _(required)_ |
| `name_prefix` | Prefix for resource names | `iacvmss` |
| `location` | Azure region | `eastus` |
| `admin_username` | Instance admin username | `azureuser` |
| `sku` | VM size for instances | `Standard_B2s` |
| `instances` | Number of instances | `2` |
| `tags` | Resource tags | see `variables.tf` |

## Prerequisites

Generate an SSH key pair if you don't already have one:

```bash
ssh-keygen -t ed25519 -C "azure-iac-templates" -f ./id_ed25519
```

## Usage

```bash
cd terraform/17-vm-scale-set
terraform init
terraform apply -var-file=terraform.tfvars.example
```

Reach individual instances via SSH through the NAT pool, e.g.
`ssh -p 50000 azureuser@<lb_public_ip>` for the first instance.
