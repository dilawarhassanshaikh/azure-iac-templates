# 07 - Azure SQL Database

Deploys an Azure SQL logical server and a single database, with an optional
firewall rule allowing other Azure services to connect.

## Architecture

![Contoso Ltd. sample architecture — SQL Database](../../docs/diagrams/07-sql-database.svg)

## Resources created

- `azurerm_resource_group`
- `random_string` (uniqueness suffix)
- `azurerm_mssql_server` (TLS 1.2 minimum)
- `azurerm_mssql_database`
- `azurerm_mssql_firewall_rule` (optional, `allow_azure_services`)

## Required inputs

| Name | Description | Default |
|------|-------------|---------|
| `admin_login` | SQL server administrator login (sensitive). No default. | _(required)_ |
| `admin_password` | SQL server administrator password (sensitive). No default. | _(required)_ |
| `name_prefix` | Prefix for resource names (random suffix appended) | `iacsql` |
| `location` | Azure region | `eastus` |
| `sku_name` | Database SKU | `Basic` |
| `max_size_gb` | Max database size (GB) | `2` |
| `allow_azure_services` | Add firewall rule for Azure services | `true` |
| `tags` | Resource tags | see `variables.tf` |

## Prerequisites

Choose a strong `admin_password`. Do not commit real credentials to source
control - pass them via `-var`, an environment variable, or a secrets manager.

## Usage

```bash
cd terraform/07-sql-database
terraform init
terraform apply -var-file=terraform.tfvars.example
```
