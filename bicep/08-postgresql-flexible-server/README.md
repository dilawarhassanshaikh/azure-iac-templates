# PostgreSQL Flexible Server (Bicep)

Deploys an Azure Database for PostgreSQL Flexible Server (version 16,
Burstable tier), a database, and an optional firewall rule that allows
other Azure services to reach the server.

## Architecture

![Contoso Ltd. sample architecture — Postgresql Flexible Server](../../docs/diagrams/08-postgresql-flexible-server.svg)

## Resources

- `Microsoft.DBforPostgreSQL/flexibleServers` - PostgreSQL 16, Burstable tier
- `Microsoft.DBforPostgreSQL/flexibleServers/databases` - database
- `Microsoft.DBforPostgreSQL/flexibleServers/firewallRules` - allows Azure services (conditional)

## Required inputs

| Parameter | Description | Default |
|---|---|---|
| `adminLogin` | Administrator login for the server | *(required)* |
| `adminPassword` | Administrator password for the server (secure) | *(required)* |
| `namePrefix` | Prefix for resource names (globally-unique suffix appended) | `pg` |
| `postgresVersion` | PostgreSQL major version | `16` |
| `skuName` | Compute SKU | `Standard_B1ms` |
| `skuTier` | Compute tier | `Burstable` |
| `storageSizeGB` | Storage size in GB | `32` |
| `databaseName` | Name of the database | `appdb` |
| `allowAzureServices` | Add a firewall rule allowing Azure services | `true` |
| `location` | Azure region | resource group location |
| `tags` | Tags applied to all resources | `{ environment: 'dev', project: 'azure-iac-templates' }` |

## Deploy

```bash
az group create --name <rg-name> --location eastus
az deployment group create --resource-group <rg-name> --template-file main.bicep --parameters main.parameters.json
```
