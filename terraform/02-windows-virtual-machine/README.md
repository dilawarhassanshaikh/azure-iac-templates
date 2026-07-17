# 02 - Windows Virtual Machine

Deploys a single Windows Server 2022 Datacenter (Azure Edition) virtual
machine with its own virtual network, subnet, network security group (RDP
only), static Standard public IP, and network interface.

## Architecture

![Contoso Ltd. sample architecture — Windows Virtual Machine](../../docs/diagrams/02-windows-virtual-machine.svg)

## Resources created

- `azurerm_resource_group`
- `azurerm_virtual_network` + `azurerm_subnet`
- `azurerm_network_security_group` (allows inbound TCP 3389 from `source_address_prefix`) + association
- `azurerm_public_ip` (Standard, static)
- `azurerm_network_interface`
- `azurerm_windows_virtual_machine` (Windows Server 2022 Datacenter Azure Edition)

## Required inputs

| Name | Description | Default |
|------|-------------|---------|
| `admin_password` | Administrator password (sensitive, 12-123 chars). No default. | _(required)_ |
| `name_prefix` | Prefix for resource names | `winvm` |
| `location` | Azure region | `eastus` |
| `admin_username` | VM admin username | `azureadmin` |
| `vm_size` | VM size | `Standard_B2s` |
| `source_address_prefix` | CIDR allowed to reach RDP; restrict in production | `*` |
| `tags` | Resource tags | see `variables.tf` |

## Prerequisites

None beyond choosing a strong `admin_password` that satisfies Azure's
complexity requirements. Do not commit real passwords to source control -
pass them via `-var`, an environment variable, or a secrets manager.

## Usage

```bash
cd terraform/02-windows-virtual-machine
terraform init
terraform apply -var-file=terraform.tfvars.example
```

Connect once deployed via RDP to the `public_ip_address` output.
