# VM Scale Set (Bicep)

Deploys a Linux Virtual Machine Scale Set (Ubuntu 22.04, SSH-key-only auth,
Manual upgrade policy) behind a Standard Load Balancer with a backend pool,
a TCP health probe on port 80, and an inbound NAT pool for SSH
(50000-50019 -> 22 on each instance).

## Architecture

![Contoso Ltd. sample architecture — VM Scale Set](../../docs/diagrams/17-vm-scale-set.svg)

## Resources

- `Microsoft.Network/virtualNetworks` - dedicated VNet for the scale set
- `Microsoft.Network/publicIPAddresses` - Standard, static
- `Microsoft.Network/loadBalancers` - Standard SKU, backend pool + probe + NAT pool
- `Microsoft.Compute/virtualMachineScaleSets` - Linux, SSH-key auth only

## Required inputs

| Parameter | Description | Default |
|---|---|---|
| `sshPublicKey` | SSH public key content used for admin login | *(required)* |
| `namePrefix` | Prefix for resource names | `vmss` |
| `instanceCount` | Number of VM instances | `2` |
| `vmSize` | VM size | `Standard_B2s` |
| `location` | Azure region | resource group location |
| `tags` | Tags applied to all resources | `{ environment: 'dev', project: 'azure-iac-templates' }` |

## Prerequisites

Generate an SSH key pair if you don't already have one:

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/azure_vmss
```

Use the contents of `~/.ssh/azure_vmss.pub` as the `sshPublicKey` parameter.

## Deploy

```bash
az group create --name <rg-name> --location eastus
az deployment group create --resource-group <rg-name> --template-file main.bicep --parameters main.parameters.json
```

To SSH into a specific instance, connect to the load balancer's public IP on
a port in the 50000-50019 range (each maps to port 22 on one instance).
