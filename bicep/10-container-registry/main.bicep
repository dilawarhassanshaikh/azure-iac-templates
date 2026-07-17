targetScope = 'resourceGroup'

@description('Prefix used to build resource names.')
param namePrefix string = 'acr'

@description('Azure region for all resources.')
param location string = resourceGroup().location

@description('Tags applied to all resources.')
param tags object = {
  environment: 'dev'
  project: 'azure-iac-templates'
}

@description('SKU for the container registry.')
param skuName string = 'Standard'

var registryName = toLower('${namePrefix}${uniqueString(resourceGroup().id)}')

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: registryName
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  properties: {
    adminUserEnabled: false
  }
}

@description('Login server hostname for the registry.')
output loginServer string = containerRegistry.properties.loginServer

@description('Resource ID of the container registry.')
output acrId string = containerRegistry.id
