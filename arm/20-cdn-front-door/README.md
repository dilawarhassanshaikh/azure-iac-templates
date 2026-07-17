# CDN / Front Door

Deploys an Azure Front Door Standard profile with an endpoint, an origin
group, an origin pointing at your backend, and a route that forwards all
paths to the origin group over HTTPS (with HTTP-to-HTTPS redirect enabled).

## Architecture

![Contoso Ltd. sample architecture — CDN Front Door](../../docs/diagrams/20-cdn-front-door.svg)

## Resources

- Microsoft.Cdn/profiles (Standard_AzureFrontDoor)
- Microsoft.Cdn/profiles/afdEndpoints
- Microsoft.Cdn/profiles/originGroups
- Microsoft.Cdn/profiles/originGroups/origins
- Microsoft.Cdn/profiles/afdEndpoints/routes

## Required inputs

| Parameter | Description | Default |
|---|---|---|
| `namePrefix` | Prefix used to build resource names (endpoint name is globally unique) | `afd` |
| `location` | Azure region for deployment metadata (Front Door resources themselves are global) | resource group location |
| `skuName` | Front Door profile SKU | `Standard_AzureFrontDoor` |
| `originHostName` | Hostname of the origin backend (required, no default) | - |
| `tags` | Tags applied to all resources | `{ environment: dev, project: azure-iac-templates }` |

## Deploy

```bash
az group create --name <rg-name> --location eastus
az deployment group create --resource-group <rg-name> --template-file azuredeploy.json --parameters azuredeploy.parameters.json
```
