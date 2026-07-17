# App Service Web App

Deploys a Linux App Service Plan and a Linux Web App running Node.js 20 LTS,
with HTTPS-only traffic enforced.

## Architecture

![Contoso Ltd. sample architecture — App Service Webapp](../../docs/diagrams/05-app-service-webapp.svg)

## Resources

- Microsoft.Web/serverfarms (Linux App Service Plan)
- Microsoft.Web/sites (Linux Web App, NODE|20-lts)

## Required inputs

| Parameter | Description | Default |
|---|---|---|
| `namePrefix` | Prefix used to build resource names (web app name is globally unique) | `webapp` |
| `location` | Azure region | resource group location |
| `skuName` | App Service Plan SKU | `B1` |
| `tags` | Tags applied to all resources | `{ environment: dev, project: azure-iac-templates }` |

## Deploy

```bash
az group create --name <rg-name> --location eastus
az deployment group create --resource-group <rg-name> --template-file azuredeploy.json --parameters azuredeploy.parameters.json
```
