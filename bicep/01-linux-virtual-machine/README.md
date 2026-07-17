# Linux Virtual Machine (Bicep)

Deploys an Ubuntu 22.04 LTS virtual machine with SSH-key-only authentication,
its own virtual network and subnet, a network security group that allows
inbound SSH from a configurable source, a Standard static public IP, and a
network interface.

## Architecture

![Contoso Ltd. sample architecture — Linux Virtual Machine](../../docs/diagrams/01-linux-virtual-machine.svg)

## Resources

- `Microsoft.Network/virtualNetworks` - dedicated VNet for the VM
- `Microsoft.Network/networkSecurityGroups` - allows inbound TCP/22
- `Microsoft.Network/publicIPAddresses` - Standard, static
- `Microsoft.Network/networkInterfaces`
- `Microsoft.Compute/virtualMachines` - Ubuntu 22.04 LTS, SSH-key auth only

## Required inputs

| Parameter | Description | Default |
|---|---|---|
| `sshPublicKey` | SSH public key content used for admin login | *(required)* |
| `namePrefix` | Prefix for resource names | `linuxvm` |
| `sourceAddressPrefix` | CIDR allowed to reach SSH (22) | `*` (restrict in production) |
| `vmSize` | VM size | `Standard_B2s` |
| `location` | Azure region | resource group location |
| `tags` | Tags applied to all resources | `{ environment: 'dev', project: 'azure-iac-templates' }` |

## Prerequisites

Generate an SSH key pair if you don't already have one:

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/azure_linux_vm
```

Use the contents of `~/.ssh/azure_linux_vm.pub` as the `sshPublicKey` parameter.

## Deploy

```bash
az group create --name <rg-name> --location eastus
az deployment group create --resource-group <rg-name> --template-file main.bicep --parameters main.parameters.json
```
