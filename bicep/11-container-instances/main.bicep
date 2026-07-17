targetScope = 'resourceGroup'

@description('Prefix used to build resource names.')
param namePrefix string = 'aci'

@description('Azure region for all resources.')
param location string = resourceGroup().location

@description('Tags applied to all resources.')
param tags object = {
  environment: 'dev'
  project: 'azure-iac-templates'
}

@description('Container image to deploy.')
param image string = 'mcr.microsoft.com/azuredocs/aci-helloworld:latest'

@description('Number of CPU cores allocated to the container.')
param cpuCores int = 1

@description('Memory in GB allocated to the container.')
param memoryInGB string = '1.5'

@description('Port exposed by the container.')
param containerPort int = 80

var containerGroupName = '${namePrefix}-cg'
var dnsNameLabel = toLower('${namePrefix}-${uniqueString(resourceGroup().id)}')

resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2023-05-01' = {
  name: containerGroupName
  location: location
  tags: tags
  properties: {
    osType: 'Linux'
    restartPolicy: 'Always'
    containers: [
      {
        name: '${namePrefix}-container'
        properties: {
          image: image
          resources: {
            requests: {
              cpu: cpuCores
              memoryInGB: json(memoryInGB)
            }
          }
          ports: [
            {
              port: containerPort
              protocol: 'TCP'
            }
          ]
        }
      }
    ]
    ipAddress: {
      type: 'Public'
      dnsNameLabel: dnsNameLabel
      ports: [
        {
          port: containerPort
          protocol: 'TCP'
        }
      ]
    }
  }
}

@description('Fully qualified domain name of the container group.')
output fqdn string = containerGroup.properties.ipAddress.fqdn

@description('Public IP address of the container group.')
output ipAddress string = containerGroup.properties.ipAddress.ip
