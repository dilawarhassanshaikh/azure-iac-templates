# Load Balancer

Deploys a Standard public Load Balancer with a static public IP, a backend
address pool, a TCP health probe, and a load balancing rule.

## Architecture

![Contoso Ltd. sample architecture — Load Balancer](../../docs/diagrams/15-load-balancer.svg)

## Resources

- Microsoft.Network/publicIPAddresses (Standard, Static)
- Microsoft.Network/loadBalancers (backend pool, TCP probe, LB rule)

## Required inputs

| Parameter | Description | Default |
|---|---|---|
| `namePrefix` | Prefix used to build resource names | `lb` |
| `location` | Azure region | resource group location |
| `probePort` | TCP port for the health probe and LB rule | `80` |
| `tags` | Tags applied to all resources | `{ environment: dev, project: azure-iac-templates }` |

## Deploy

```bash
az group create --name <rg-name> --location eastus
az deployment group create --resource-group <rg-name> --template-file azuredeploy.json --parameters azuredeploy.parameters.json
```
