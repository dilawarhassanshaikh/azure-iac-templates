targetScope = 'resourceGroup'

@description('Prefix used to build resource names.')
param namePrefix string = 'redis'

@description('Azure region for all resources.')
param location string = resourceGroup().location

@description('Tags applied to all resources.')
param tags object = {
  environment: 'dev'
  project: 'azure-iac-templates'
}

@description('SKU name for the Redis cache.')
param skuName string = 'Basic'

@description('SKU family for the Redis cache (C = Basic/Standard, P = Premium).')
param skuFamily string = 'C'

@description('Cache capacity/size (meaning depends on SKU family).')
param capacity int = 0

var redisName = toLower('${namePrefix}-${uniqueString(resourceGroup().id)}')

resource redisCache 'Microsoft.Cache/redis@2023-08-01' = {
  name: redisName
  location: location
  tags: tags
  properties: {
    sku: {
      name: skuName
      family: skuFamily
      capacity: capacity
    }
    minimumTlsVersion: '1.2'
    enableNonSslPort: false
  }
}

@description('Hostname of the Redis cache.')
output hostName string = redisCache.properties.hostName

@description('SSL port of the Redis cache.')
output sslPort int = redisCache.properties.sslPort
