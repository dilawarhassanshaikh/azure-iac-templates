# Cosmos DB

Deploys an Azure Cosmos DB account (SQL API, `GlobalDocumentDB` kind,
Session consistency, single region), a SQL database, and a container.

## Architecture

![Contoso Ltd. sample architecture — Cosmos Db](../../docs/diagrams/13-cosmos-db.svg)

## Resources

- Microsoft.DocumentDB/databaseAccounts
- Microsoft.DocumentDB/databaseAccounts/sqlDatabases
- Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers

## Required inputs

| Parameter | Description | Default |
|---|---|---|
| `namePrefix` | Prefix used to build the (globally-unique) account name | `cosmos` |
| `location` | Azure region | resource group location |
| `databaseName` | SQL API database name | `appdb` |
| `containerName` | SQL API container name | `items` |
| `partitionKeyPath` | Partition key path for the container | `/id` |
| `tags` | Tags applied to all resources | `{ environment: dev, project: azure-iac-templates }` |

## Deploy

```bash
az group create --name <rg-name> --location eastus
az deployment group create --resource-group <rg-name> --template-file azuredeploy.json --parameters azuredeploy.parameters.json
```
