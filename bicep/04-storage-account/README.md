# Storage Account (Bicep)

Deploys a general-purpose v2 storage account with secure defaults (TLS 1.2
minimum, HTTPS-only traffic, blob public access disabled) and a sample blob
container.

## Architecture

![Contoso Ltd. sample architecture — Storage Account](../../docs/diagrams/04-storage-account.svg)

## Resources

- `Microsoft.Storage/storageAccounts` - StorageV2, secure defaults
- `Microsoft.Storage/storageAccounts/blobServices`
- `Microsoft.Storage/storageAccounts/blobServices/containers` - sample container

## Required inputs

| Parameter | Description | Default |
|---|---|---|
| `namePrefix` | Prefix for resource names (globally-unique suffix appended) | `st` |
| `skuName` | Storage account SKU | `Standard_LRS` |
| `containerName` | Name of the sample blob container | `sample` |
| `location` | Azure region | resource group location |
| `tags` | Tags applied to all resources | `{ environment: 'dev', project: 'azure-iac-templates' }` |

## Deploy

```bash
az group create --name <rg-name> --location eastus
az deployment group create --resource-group <rg-name> --template-file main.bicep --parameters main.parameters.json
```
