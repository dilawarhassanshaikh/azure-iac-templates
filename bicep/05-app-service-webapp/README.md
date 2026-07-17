# App Service Web App (Bicep)

Deploys a Linux App Service Plan and a Linux Web App running Node.js 20 LTS,
with HTTPS-only traffic enforced.

## Architecture

![Contoso Ltd. sample architecture — App Service Webapp](../../docs/diagrams/05-app-service-webapp.svg)

## Resources

- `Microsoft.Web/serverfarms` - Linux App Service Plan
- `Microsoft.Web/sites` - Linux Web App (`NODE|20-lts`)

## Required inputs

| Parameter | Description | Default |
|---|---|---|
| `namePrefix` | Prefix for resource names (globally-unique suffix appended) | `webapp` |
| `skuName` | App Service Plan SKU | `B1` |
| `location` | Azure region | resource group location |
| `tags` | Tags applied to all resources | `{ environment: 'dev', project: 'azure-iac-templates' }` |

## Deploy

```bash
az group create --name <rg-name> --location eastus
az deployment group create --resource-group <rg-name> --template-file main.bicep --parameters main.parameters.json
```
