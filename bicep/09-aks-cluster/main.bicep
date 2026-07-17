targetScope = 'resourceGroup'

@description('Prefix used to build resource names.')
param namePrefix string = 'aks'

@description('Azure region for all resources.')
param location string = resourceGroup().location

@description('Tags applied to all resources.')
param tags object = {
  environment: 'dev'
  project: 'azure-iac-templates'
}

@description('DNS prefix for the AKS control plane.')
param dnsPrefix string = '${namePrefix}-dns'

@description('VM size for the default node pool.')
param agentVmSize string = 'Standard_DS2_v2'

@description('Number of nodes in the default node pool.')
param agentCount int = 2

@description('Kubernetes version. Leave empty to use the default supported version.')
param kubernetesVersion string = ''

var clusterName = '${namePrefix}-cluster'

resource aksCluster 'Microsoft.ContainerService/managedClusters@2024-02-01' = {
  name: clusterName
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: dnsPrefix
    kubernetesVersion: empty(kubernetesVersion) ? null : kubernetesVersion
    agentPoolProfiles: [
      {
        name: 'systempool'
        count: agentCount
        vmSize: agentVmSize
        osType: 'Linux'
        mode: 'System'
        type: 'VirtualMachineScaleSets'
      }
    ]
  }
}

@description('Resource ID of the AKS cluster.')
output clusterId string = aksCluster.id

@description('FQDN of the AKS control plane.')
output controlPlaneFqdn string = aksCluster.properties.fqdn
