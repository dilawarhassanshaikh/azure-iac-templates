# Log Analytics Workspace

Deploys a Log Analytics workspace (PerGB2018 SKU) and a workspace-based
Application Insights component.

## Architecture

![Contoso Ltd. sample architecture — Log Analytics Workspace](../../docs/diagrams/19-log-analytics-workspace.svg)

## Resources

- Microsoft.OperationalInsights/workspaces
- Microsoft.Insights/components (workspace-based Application Insights)

## Required inputs

| Parameter | Description | Default |
|---|---|---|
| `namePrefix` | Prefix used to build the (globally-unique) workspace name | `log` |
| `location` | Azure region | resource group location |
| `retentionInDays` | Data retention period in days | `30` |
| `tags` | Tags applied to all resources | `{ environment: dev, project: azure-iac-templates }` |

## Deploy

```bash
az group create --name <rg-name> --location eastus
az deployment group create --resource-group <rg-name> --template-file azuredeploy.json --parameters azuredeploy.parameters.json
```
