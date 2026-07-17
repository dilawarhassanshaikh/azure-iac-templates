# 04 - Storage Account

Deploys a general-purpose v2 storage account with secure defaults
(TLS 1.2 minimum, HTTPS-only traffic, public blob access disabled) and a
sample private blob container.

## Architecture

![Contoso Ltd. sample architecture — Storage Account](../../docs/diagrams/04-storage-account.svg)

## Resources created

- `azurerm_resource_group`
- `random_string` (uniqueness suffix)
- `azurerm_storage_account` (StorageV2, secure defaults)
- `azurerm_storage_container` (`sample`, private)

## Required inputs

| Name | Description | Default |
|------|-------------|---------|
| `name_prefix` | Prefix for the storage account name (random suffix appended) | `iacsa` |
| `location` | Azure region | `eastus` |
| `account_tier` | Storage performance tier | `Standard` |
| `account_replication_type` | Replication type | `LRS` |
| `tags` | Resource tags | see `variables.tf` |

No inputs are required beyond the defaults; this module deploys standalone.

## Usage

```bash
cd terraform/04-storage-account
terraform init
terraform apply -var-file=terraform.tfvars.example
```
