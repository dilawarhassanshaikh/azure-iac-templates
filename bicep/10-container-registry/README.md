# Container Registry (Bicep)

Deploys an Azure Container Registry (ACR) with admin user access disabled
(use `az acr login` / managed identity / RBAC for authentication instead).

## Architecture

![Contoso Ltd. sample architecture — Container Registry](../../docs/diagrams/10-container-registry.svg)

## Resources

- `Microsoft.ContainerRegistry/registries` - ACR, admin user disabled

## Required inputs

| Parameter | Description | Default |
|---|---|---|
| `namePrefix` | Prefix for resource names (globally-unique suffix appended) | `acr` |
| `skuName` | Registry SKU | `Standard` |
| `location` | Azure region | resource group location |
| `tags` | Tags applied to all resources | `{ environment: 'dev', project: 'azure-iac-templates' }` |

## Deploy

```bash
az group create --name <rg-name> --location eastus
az deployment group create --resource-group <rg-name> --template-file main.bicep --parameters main.parameters.json
```
