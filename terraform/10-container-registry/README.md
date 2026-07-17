# 10 - Container Registry

Deploys an Azure Container Registry (ACR) with the admin account disabled;
use `az acr login` or a managed identity / service principal for
authentication instead.

## Architecture

![Contoso Ltd. sample architecture — Container Registry](../../docs/diagrams/10-container-registry.svg)

## Resources created

- `azurerm_resource_group`
- `random_string` (uniqueness suffix)
- `azurerm_container_registry` (`admin_enabled = false`)

## Required inputs

| Name | Description | Default |
|------|-------------|---------|
| `name_prefix` | Prefix for the registry name (random suffix appended) | `iacacr` |
| `location` | Azure region | `eastus` |
| `sku` | Registry SKU | `Standard` |
| `tags` | Resource tags | see `variables.tf` |

No inputs are required beyond the defaults; this module deploys standalone.

## Usage

```bash
cd terraform/10-container-registry
terraform init
terraform apply -var-file=terraform.tfvars.example
```

Authenticate and push an image:

```bash
az acr login --name <login_server without .azurecr.io>
docker push <login_server>/myimage:tag
```
