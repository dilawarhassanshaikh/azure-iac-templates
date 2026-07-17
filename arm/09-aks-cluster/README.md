# AKS Cluster

Deploys an Azure Kubernetes Service (AKS) managed cluster with a
system-assigned identity and a single system node pool.

## Architecture

![Contoso Ltd. sample architecture — AKS Cluster](../../docs/diagrams/09-aks-cluster.svg)

## Resources

- Microsoft.ContainerService/managedClusters

## Required inputs

| Parameter | Description | Default |
|---|---|---|
| `namePrefix` | Prefix used to build resource names | `aks` |
| `location` | Azure region | resource group location |
| `dnsPrefix` | DNS prefix for the control plane | `aks-<uniqueString>` |
| `nodeCount` | Number of agent nodes | `2` |
| `nodeVmSize` | VM size for agent nodes | `Standard_DS2_v2` |
| `tags` | Tags applied to all resources | `{ environment: dev, project: azure-iac-templates }` |

## Deploy

```bash
az group create --name <rg-name> --location eastus
az deployment group create --resource-group <rg-name> --template-file azuredeploy.json --parameters azuredeploy.parameters.json
```
