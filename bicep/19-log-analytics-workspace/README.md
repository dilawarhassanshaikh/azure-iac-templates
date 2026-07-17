# Log Analytics Workspace (Bicep)

Deploys a Log Analytics workspace (PerGB2018 SKU) and a workspace-based
Application Insights component linked to it.

## Architecture

![Contoso Ltd. sample architecture — Log Analytics Workspace](../../docs/diagrams/19-log-analytics-workspace.svg)

## Resources

- `Microsoft.OperationalInsights/workspaces` - PerGB2018 SKU
- `Microsoft.Insights/components` - workspace-based Application Insights

## Required inputs

| Parameter | Description | Default |
|---|---|---|
| `namePrefix` | Prefix for resource names | `log` |
| `retentionInDays` | Data retention period in days | `30` |
| `location` | Azure region | resource group location |
| `tags` | Tags applied to all resources | `{ environment: 'dev', project: 'azure-iac-templates' }` |

## Deploy

```bash
az group create --name <rg-name> --location eastus
az deployment group create --resource-group <rg-name> --template-file main.bicep --parameters main.parameters.json
```
