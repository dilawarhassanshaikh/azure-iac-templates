# 12 - Key Vault

Deploys an Azure Key Vault configured for RBAC authorization (rather than
legacy access policies). Grant access via `azurerm_role_assignment`
(e.g. `Key Vault Secrets Officer`) on the resulting vault, scoped to the
principals that need it.

## Architecture

![Contoso Ltd. sample architecture — Key Vault](../../docs/diagrams/12-key-vault.svg)

## Resources created

- `azurerm_resource_group`
- `random_string` (uniqueness suffix)
- `azurerm_key_vault` (`sku_name = "standard"`, `enable_rbac_authorization = true`)

## Required inputs

| Name | Description | Default |
|------|-------------|---------|
| `name_prefix` | Prefix for the vault name (random suffix appended) | `iackv` |
| `location` | Azure region | `eastus` |
| `purge_protection_enabled` | Enable purge protection (recommended `true` for production) | `false` |
| `tags` | Resource tags | see `variables.tf` |

No inputs are required beyond the defaults; this module deploys standalone.

## Prerequisites

The Azure CLI / provider identity used to run `terraform apply` must be
authenticated (`az login`) so the module can resolve the current tenant ID
via the `azurerm_client_config` data source.

## Usage

```bash
cd terraform/12-key-vault
terraform init
terraform apply -var-file=terraform.tfvars.example
```

**Note:** `purge_protection_enabled = false` (the default) makes teardown of
this example easy, but it also means deleted secrets/keys can be permanently
purged before their retention window. Set it to `true` for any real
production vault.
