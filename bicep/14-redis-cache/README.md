# Redis Cache (Bicep)

Deploys an Azure Cache for Redis instance with TLS 1.2 minimum and the
non-SSL port disabled.

## Architecture

![Contoso Ltd. sample architecture — Redis Cache](../../docs/diagrams/14-redis-cache.svg)

## Resources

- `Microsoft.Cache/redis` - Basic/Standard/Premium tier cache

## Required inputs

| Parameter | Description | Default |
|---|---|---|
| `namePrefix` | Prefix for resource names (globally-unique suffix appended) | `redis` |
| `skuName` | Cache SKU name | `Basic` |
| `skuFamily` | Cache SKU family (`C` or `P`) | `C` |
| `capacity` | Cache size | `0` |
| `location` | Azure region | resource group location |
| `tags` | Tags applied to all resources | `{ environment: 'dev', project: 'azure-iac-templates' }` |

## Deploy

```bash
az group create --name <rg-name> --location eastus
az deployment group create --resource-group <rg-name> --template-file main.bicep --parameters main.parameters.json
```
