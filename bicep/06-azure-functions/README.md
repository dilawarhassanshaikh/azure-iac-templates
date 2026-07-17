# Azure Functions (Bicep)

Deploys a Consumption-plan (Y1) Function App on Linux with a backing storage
account and Application Insights instrumentation wired in via app settings.

## Architecture

![Contoso Ltd. sample architecture — Azure Functions](../../docs/diagrams/06-azure-functions.svg)

## Resources

- `Microsoft.Storage/storageAccounts` - required by the Functions runtime
- `Microsoft.Insights/components` - Application Insights
- `Microsoft.Web/serverfarms` - Consumption plan (`Y1` / `Dynamic`)
- `Microsoft.Web/sites` - Function App (`functionapp,linux`)

## Required inputs

| Parameter | Description | Default |
|---|---|---|
| `namePrefix` | Prefix for resource names (globally-unique suffix appended) | `func` |
| `functionsWorkerRuntime` | Functions worker runtime stack | `node` |
| `location` | Azure region | resource group location |
| `tags` | Tags applied to all resources | `{ environment: 'dev', project: 'azure-iac-templates' }` |

## Deploy

```bash
az group create --name <rg-name> --location eastus
az deployment group create --resource-group <rg-name> --template-file main.bicep --parameters main.parameters.json
```
