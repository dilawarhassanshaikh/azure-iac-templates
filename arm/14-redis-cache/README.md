# Redis Cache

Deploys an Azure Cache for Redis instance with TLS 1.2 minimum and the
non-SSL port disabled.

## Architecture

![Contoso Ltd. sample architecture — Redis Cache](../../docs/diagrams/14-redis-cache.svg)

## Resources

- Microsoft.Cache/redis

## Required inputs

| Parameter | Description | Default |
|---|---|---|
| `namePrefix` | Prefix used to build the (globally-unique) cache name | `redis` |
| `location` | Azure region | resource group location |
| `skuName` | Redis SKU name | `Basic` |
| `skuCapacity` | Redis SKU capacity/size | `0` |
| `tags` | Tags applied to all resources | `{ environment: dev, project: azure-iac-templates }` |

## Deploy

```bash
az group create --name <rg-name> --location eastus
az deployment group create --resource-group <rg-name> --template-file azuredeploy.json --parameters azuredeploy.parameters.json
```
