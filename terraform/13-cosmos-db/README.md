# 13 - Cosmos DB

Deploys a single-region Azure Cosmos DB account (SQL API, Session
consistency) with a database and a container.

## Architecture

![Contoso Ltd. sample architecture — Cosmos Db](../../docs/diagrams/13-cosmos-db.svg)

## Resources created

- `azurerm_resource_group`
- `random_string` (uniqueness suffix)
- `azurerm_cosmosdb_account` (`kind = "GlobalDocumentDB"`, Session consistency, single region)
- `azurerm_cosmosdb_sql_database`
- `azurerm_cosmosdb_sql_container` (partition key `/id`)

## Required inputs

| Name | Description | Default |
|------|-------------|---------|
| `name_prefix` | Prefix for the account name (random suffix appended) | `iaccosmos` |
| `location` | Azure region | `eastus` |
| `tags` | Resource tags | see `variables.tf` |

No inputs are required beyond the defaults; this module deploys standalone.

## Usage

```bash
cd terraform/13-cosmos-db
terraform init
terraform apply -var-file=terraform.tfvars.example
```
