# SQL Database

Deploys an Azure SQL logical server and a single database, with an optional
firewall rule allowing other Azure services to connect.

## Architecture

![Contoso Ltd. sample architecture — SQL Database](../../docs/diagrams/07-sql-database.svg)

## Resources

- Microsoft.Sql/servers (logical server)
- Microsoft.Sql/servers/databases
- Microsoft.Sql/servers/firewallRules (conditional on `allowAzureServices`)

## Required inputs

| Parameter | Description | Default |
|---|---|---|
| `namePrefix` | Prefix used to build the (globally-unique) SQL server name | `sqldb` |
| `location` | Azure region | resource group location |
| `adminLogin` | SQL server admin login (required, no default) | - |
| `adminPassword` | SQL server admin password (required, secureString, no default) | - |
| `skuName` | Database SKU/tier name | `Basic` |
| `allowAzureServices` | Add firewall rule allowing Azure services | `true` |
| `databaseName` | Database name | `appdb` |
| `tags` | Tags applied to all resources | `{ environment: dev, project: azure-iac-templates }` |

## Deploy

```bash
az group create --name <rg-name> --location eastus
az deployment group create --resource-group <rg-name> --template-file azuredeploy.json --parameters azuredeploy.parameters.json
```
