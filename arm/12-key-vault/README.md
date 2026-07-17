# Key Vault

Deploys an Azure Key Vault with RBAC authorization enabled (no access
policies), soft-delete enabled, and optional purge protection.

## Architecture

![Contoso Ltd. sample architecture — Key Vault](../../docs/diagrams/12-key-vault.svg)

## Resources

- Microsoft.KeyVault/vaults

## Required inputs

| Parameter | Description | Default |
|---|---|---|
| `namePrefix` | Prefix used to build the (globally-unique) vault name | `kv` |
| `location` | Azure region | resource group location |
| `enablePurgeProtection` | Enable purge protection (irreversible once enabled) | `false` |
| `tags` | Tags applied to all resources | `{ environment: dev, project: azure-iac-templates }` |

## Deploy

```bash
az group create --name <rg-name> --location eastus
az deployment group create --resource-group <rg-name> --template-file azuredeploy.json --parameters azuredeploy.parameters.json
```
