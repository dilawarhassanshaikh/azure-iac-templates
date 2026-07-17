# Container Instances

Deploys a single Azure Container Instance (ACI) container group with a
public IP address and DNS name label.

## Architecture

![Contoso Ltd. sample architecture — Container Instances](../../docs/diagrams/11-container-instances.svg)

## Resources

- Microsoft.ContainerInstance/containerGroups

## Required inputs

| Parameter | Description | Default |
|---|---|---|
| `namePrefix` | Prefix used to build resource names (DNS name label is globally unique) | `aci` |
| `location` | Azure region | resource group location |
| `image` | Container image to deploy | `mcr.microsoft.com/azuredocs/aci-helloworld:latest` |
| `cpuCores` | CPU cores allocated | `1` |
| `memoryInGB` | Memory in GB allocated | `1.5` |
| `port` | TCP port exposed | `80` |
| `tags` | Tags applied to all resources | `{ environment: dev, project: azure-iac-templates }` |

## Deploy

```bash
az group create --name <rg-name> --location eastus
az deployment group create --resource-group <rg-name> --template-file azuredeploy.json --parameters azuredeploy.parameters.json
```
