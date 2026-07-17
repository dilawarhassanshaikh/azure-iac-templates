# Azure Front Door (CDN) (Bicep)

Deploys an Azure Front Door Standard profile with an endpoint, an origin
group with a health probe, a single origin, and a route that forwards all
paths to the origin group with HTTPS redirect enabled.

## Architecture

![Contoso Ltd. sample architecture — CDN Front Door](../../docs/diagrams/20-cdn-front-door.svg)

## Resources

- `Microsoft.Cdn/profiles` - Front Door Standard profile
- `Microsoft.Cdn/profiles/afdEndpoints` - endpoint
- `Microsoft.Cdn/profiles/originGroups` - origin group with health probe
- `Microsoft.Cdn/profiles/originGroups/origins` - origin
- `Microsoft.Cdn/profiles/afdEndpoints/routes` - route (HTTPS redirect enabled)

## Required inputs

| Parameter | Description | Default |
|---|---|---|
| `originHostName` | Hostname of the backend origin (e.g. App Service default hostname) | *(required)* |
| `namePrefix` | Prefix for resource names (globally-unique endpoint name appended) | `afd` |
| `skuName` | Front Door profile SKU | `Standard_AzureFrontDoor` |
| `location` | Azure region for resource metadata (Front Door itself is global) | resource group location |
| `tags` | Tags applied to all resources | `{ environment: 'dev', project: 'azure-iac-templates' }` |

## Deploy

```bash
az group create --name <rg-name> --location eastus
az deployment group create --resource-group <rg-name> --template-file main.bicep --parameters main.parameters.json
```
