# Linux Virtual Machine

Deploys a single Ubuntu 22.04 LTS virtual machine with its own virtual
network, subnet, network security group (SSH access only), static Standard
public IP address, and network interface. Authentication is SSH-key only
(password authentication is disabled).

## Architecture

![Contoso Ltd. sample architecture — Linux Virtual Machine](../../docs/diagrams/01-linux-virtual-machine.svg)

## Resources

- Microsoft.Network/networkSecurityGroups (allows inbound TCP 22)
- Microsoft.Network/virtualNetworks (1 subnet)
- Microsoft.Network/publicIPAddresses (Standard, Static)
- Microsoft.Network/networkInterfaces
- Microsoft.Compute/virtualMachines (Ubuntu 22.04 LTS Gen2)

## Required inputs

| Parameter | Description | Default |
|---|---|---|
| `namePrefix` | Prefix used to build resource names | `linuxvm` |
| `location` | Azure region | resource group location |
| `vmSize` | VM size | `Standard_B2s` |
| `adminUsername` | Admin username | `azureuser` |
| `sshPublicKey` | SSH public key content (required, no default) | - |
| `sourceAddressPrefix` | CIDR/`*` allowed to reach SSH 22 | `*` (restrict in production) |
| `tags` | Tags applied to all resources | `{ environment: dev, project: azure-iac-templates }` |

## Prerequisites

Generate an SSH key pair if you don't already have one:

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/azure_linux_vm
```

Then set `sshPublicKey` in `azuredeploy.parameters.json` to the contents of
`~/.ssh/azure_linux_vm.pub`.

## Deploy

```bash
az group create --name <rg-name> --location eastus
az deployment group create --resource-group <rg-name> --template-file azuredeploy.json --parameters azuredeploy.parameters.json
```
