# AKS Cluster (Bicep)

Deploys an Azure Kubernetes Service (AKS) managed cluster with a
system-assigned managed identity and a single system node pool.

## Architecture

![Contoso Ltd. sample architecture — AKS Cluster](../../docs/diagrams/09-aks-cluster.svg)

## Resources

- `Microsoft.ContainerService/managedClusters` - AKS cluster (SystemAssigned identity)

## Required inputs

| Parameter | Description | Default |
|---|---|---|
| `namePrefix` | Prefix for resource names | `aks` |
| `dnsPrefix` | DNS prefix for the control plane | `<namePrefix>-dns` |
| `agentVmSize` | VM size for the default node pool | `Standard_DS2_v2` |
| `agentCount` | Number of nodes in the default node pool | `2` |
| `kubernetesVersion` | Kubernetes version (empty = default) | `""` |
| `location` | Azure region | resource group location |
| `tags` | Tags applied to all resources | `{ environment: 'dev', project: 'azure-iac-templates' }` |

## Deploy

```bash
az group create --name <rg-name> --location eastus
az deployment group create --resource-group <rg-name> --template-file main.bicep --parameters main.parameters.json
```

After deployment, connect with:

```bash
az aks get-credentials --resource-group <rg-name> --name <namePrefix>-cluster
```
