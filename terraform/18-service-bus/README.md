# 18 - Service Bus

Deploys a Service Bus namespace and a queue.

## Architecture

![Contoso Ltd. sample architecture — Service Bus](../../docs/diagrams/18-service-bus.svg)

## Resources created

- `azurerm_resource_group`
- `random_string` (uniqueness suffix)
- `azurerm_servicebus_namespace`
- `azurerm_servicebus_queue`

## Required inputs

| Name | Description | Default |
|------|-------------|---------|
| `name_prefix` | Prefix for the namespace name (random suffix appended) | `iacsb` |
| `location` | Azure region | `eastus` |
| `sku` | Namespace SKU | `Standard` |
| `max_size_in_megabytes` | Max queue size (MB) | `1024` |
| `tags` | Resource tags | see `variables.tf` |

No inputs are required beyond the defaults; this module deploys standalone.

## Usage

```bash
cd terraform/18-service-bus
terraform init
terraform apply -var-file=terraform.tfvars.example
```
