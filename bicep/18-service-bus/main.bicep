targetScope = 'resourceGroup'

@description('Prefix used to build resource names.')
param namePrefix string = 'sb'

@description('Azure region for all resources.')
param location string = resourceGroup().location

@description('Tags applied to all resources.')
param tags object = {
  environment: 'dev'
  project: 'azure-iac-templates'
}

@description('SKU name for the Service Bus namespace.')
param skuName string = 'Standard'

@description('Name of the queue to create.')
param queueName string = 'appqueue'

@description('Maximum queue size in megabytes.')
param maxSizeInMegabytes int = 1024

var namespaceName = toLower('${namePrefix}-${uniqueString(resourceGroup().id)}')

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2021-11-01' = {
  name: namespaceName
  location: location
  tags: tags
  sku: {
    name: skuName
    tier: skuName
  }
  properties: {}
}

resource queue 'Microsoft.ServiceBus/namespaces/queues@2021-11-01' = {
  parent: serviceBusNamespace
  name: queueName
  properties: {
    maxSizeInMegabytes: maxSizeInMegabytes
  }
}

@description('Resource ID of the Service Bus namespace.')
output namespaceId string = serviceBusNamespace.id

@description('Name of the queue.')
output queueName string = queue.name
