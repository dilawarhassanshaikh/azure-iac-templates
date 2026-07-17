# Service Bus

Deploys a Service Bus namespace and a queue.

## Architecture

![Contoso Ltd. sample architecture — Service Bus](../../docs/diagrams/18-service-bus.svg)

## Resources

- Microsoft.ServiceBus/namespaces
- Microsoft.ServiceBus/namespaces/queues

## Required inputs

| Parameter | Description | Default |
|---|---|---|
| `namePrefix` | Prefix used to build the (globally-unique) namespace name | `sb` |
| `location` | Azure region | resource group location |
| `skuName` | Namespace SKU | `Standard` |
| `queueName` | Queue name | `appqueue` |
| `maxSizeInMegabytes` | Maximum queue size in MB | `1024` |
| `tags` | Tags applied to all resources | `{ environment: dev, project: azure-iac-templates }` |

## Deploy

```bash
az group create --name <rg-name> --location eastus
az deployment group create --resource-group <rg-name> --template-file azuredeploy.json --parameters azuredeploy.parameters.json
```
