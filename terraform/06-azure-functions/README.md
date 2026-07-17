# 06 - Azure Functions

Deploys a Consumption-plan (Y1) Linux Function App with its required storage
account and a workspace-based Application Insights instance linked for
monitoring.

## Architecture

![Contoso Ltd. sample architecture — Azure Functions](../../docs/diagrams/06-azure-functions.svg)

## Resources created

- `azurerm_resource_group`
- `random_string` (uniqueness suffix)
- `azurerm_storage_account` (required by the Function App runtime)
- `azurerm_log_analytics_workspace`
- `azurerm_application_insights` (workspace-based)
- `azurerm_service_plan` (Linux, `Y1` Consumption)
- `azurerm_linux_function_app` (Node.js stack, App Insights linked)

## Required inputs

| Name | Description | Default |
|------|-------------|---------|
| `name_prefix` | Prefix for resource names (random suffix appended) | `iacfunc` |
| `location` | Azure region | `eastus` |
| `node_version` | Node.js runtime version | `20` |
| `tags` | Resource tags | see `variables.tf` |

No inputs are required beyond the defaults; this module deploys standalone.

## Usage

```bash
cd terraform/06-azure-functions
terraform init
terraform apply -var-file=terraform.tfvars.example
```
