# Windows Virtual Machine (Bicep)

Deploys a Windows Server 2022 Datacenter Azure Edition virtual machine with
its own virtual network and subnet, a network security group that allows
inbound RDP from a configurable source, a Standard static public IP, and a
network interface.

## Architecture

![Contoso Ltd. sample architecture — Windows Virtual Machine](../../docs/diagrams/02-windows-virtual-machine.svg)

## Resources

- `Microsoft.Network/virtualNetworks` - dedicated VNet for the VM
- `Microsoft.Network/networkSecurityGroups` - allows inbound TCP/3389
- `Microsoft.Network/publicIPAddresses` - Standard, static
- `Microsoft.Network/networkInterfaces`
- `Microsoft.Compute/virtualMachines` - Windows Server 2022 Datacenter Azure Edition

## Required inputs

| Parameter | Description | Default |
|---|---|---|
| `adminUsername` | Admin username for the VM | *(required)* |
| `adminPassword` | Admin password for the VM (secure) | *(required)* |
| `namePrefix` | Prefix for resource names | `winvm` |
| `sourceAddressPrefix` | CIDR allowed to reach RDP (3389) | `*` (restrict in production) |
| `vmSize` | VM size | `Standard_B2s` |
| `location` | Azure region | resource group location |
| `tags` | Tags applied to all resources | `{ environment: 'dev', project: 'azure-iac-templates' }` |

## Deploy

```bash
az group create --name <rg-name> --location eastus
az deployment group create --resource-group <rg-name> --template-file main.bicep --parameters main.parameters.json
```

> Note: `adminPassword` must satisfy Azure's complexity requirements (12-123
> characters, three of: uppercase, lowercase, digit, special character).
> Prefer overriding it at deploy time with `--parameters adminPassword=<value>`
> rather than committing a real password to the parameters file.
