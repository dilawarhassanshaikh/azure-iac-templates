targetScope = 'resourceGroup'

@description('Prefix used to build resource names.')
param namePrefix string = 'st'

@description('Azure region for all resources.')
param location string = resourceGroup().location

@description('Tags applied to all resources.')
param tags object = {
  environment: 'dev'
  project: 'azure-iac-templates'
}

@description('Storage account SKU.')
param skuName string = 'Standard_LRS'

@description('Name of the sample blob container to create.')
param containerName string = 'sample'

var storageAccountName = toLower('${namePrefix}${uniqueString(resourceGroup().id)}')

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = {
  parent: storageAccount
  name: 'default'
}

resource sampleContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: blobService
  name: containerName
  properties: {
    publicAccess: 'None'
  }
}

@description('Resource ID of the storage account.')
output storageAccountId string = storageAccount.id

@description('Primary blob service endpoint.')
output primaryBlobEndpoint string = storageAccount.properties.primaryEndpoints.blob
