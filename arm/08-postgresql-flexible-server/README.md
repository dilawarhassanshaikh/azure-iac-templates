# PostgreSQL Flexible Server

Deploys an Azure Database for PostgreSQL Flexible Server (version 16,
Burstable tier), a database, and an optional firewall rule allowing other
Azure services to connect.

## Architecture

![Contoso Ltd. sample architecture — Postgresql Flexible Server](../../docs/diagrams/08-postgresql-flexible-server.svg)

## Resources

- Microsoft.DBforPostgreSQL/flexibleServers
- Microsoft.DBforPostgreSQL/flexibleServers/databases
- Microsoft.DBforPostgreSQL/flexibleServers/firewallRules (conditional on `allowAzureServices`)

## Required inputs

| Parameter | Description | Default |
|---|---|---|
| `namePrefix` | Prefix used to build the (globally-unique) server name | `pg` |
| `location` | Azure region | resource group location |
| `administratorLogin` | Server admin login (required, no default) | - |
| `administratorLoginPassword` | Server admin password (required, secureString, no default) | - |
| `skuName` | Compute SKU | `Standard_B1ms` |
| `storageSizeGB` | Storage size in GB | `32` |
| `databaseName` | Database name | `appdb` |
| `allowAzureServices` | Add firewall rule allowing Azure services | `true` |
| `tags` | Tags applied to all resources | `{ environment: dev, project: azure-iac-templates }` |

## Deploy

```bash
az group create --name <rg-name> --location eastus
az deployment group create --resource-group <rg-name> --template-file azuredeploy.json --parameters azuredeploy.parameters.json
```
