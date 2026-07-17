# Application Gateway

Deploys a WAF_v2 Application Gateway (autoscaling 1-3 instances) with a
dedicated virtual network/subnet, a static Standard public IP, a backend
address pool (placeholder IPs), an HTTP listener, and a basic routing rule.

## Architecture

![Contoso Ltd. sample architecture — Application Gateway](../../docs/diagrams/16-application-gateway.svg)

## Resources

- Microsoft.Network/virtualNetworks (dedicated subnet for the gateway)
- Microsoft.Network/publicIPAddresses (Standard, Static)
- Microsoft.Network/applicationGateways (WAF_v2, autoscale, backend pool, listener, routing rule)

## Required inputs

| Parameter | Description | Default |
|---|---|---|
| `namePrefix` | Prefix used to build resource names | `agw` |
| `location` | Azure region | resource group location |
| `skuName` | Application Gateway SKU | `WAF_v2` |
| `minCapacity` | Minimum autoscale instance count | `1` |
| `maxCapacity` | Maximum autoscale instance count | `3` |
| `backendIpAddresses` | Placeholder backend IP addresses | `["10.30.1.4", "10.30.1.5"]` |
| `tags` | Tags applied to all resources | `{ environment: dev, project: azure-iac-templates }` |

Replace `backendIpAddresses` with the real IP addresses of your backend
servers before deploying to a live environment.

## Deploy

```bash
az group create --name <rg-name> --location eastus
az deployment group create --resource-group <rg-name> --template-file azuredeploy.json --parameters azuredeploy.parameters.json
```
