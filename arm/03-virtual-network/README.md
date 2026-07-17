# Virtual Network

Deploys a virtual network with three subnets (`web`, `app`, `data`), each
with its own network security group and sane default rules for a typical
three-tier application topology.

## Architecture

![Contoso Ltd. sample architecture — Virtual Network](../../docs/diagrams/03-virtual-network.svg)

## Resources

- Microsoft.Network/networkSecurityGroups (x3: web, app, data)
- Microsoft.Network/virtualNetworks (3 subnets: web 10.0.1.0/24, app 10.0.2.0/24, data 10.0.3.0/24)

## Required inputs

| Parameter | Description | Default |
|---|---|---|
| `namePrefix` | Prefix used to build resource names | `vnet` |
| `location` | Azure region | resource group location |
| `addressSpace` | Address space for the virtual network | `["10.0.0.0/16"]` |
| `tags` | Tags applied to all resources | `{ environment: dev, project: azure-iac-templates }` |

## Deploy

```bash
az group create --name <rg-name> --location eastus
az deployment group create --resource-group <rg-name> --template-file azuredeploy.json --parameters azuredeploy.parameters.json
```
