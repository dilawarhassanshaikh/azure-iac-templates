targetScope = 'resourceGroup'

@description('Prefix used to build resource names.')
param namePrefix string = 'kv'

@description('Azure region for all resources.')
param location string = resourceGroup().location

@description('Tags applied to all resources.')
param tags object = {
  environment: 'dev'
  project: 'azure-iac-templates'
}

@description('Whether to enable purge protection. Cannot be disabled once enabled.')
param enablePurgeProtection bool = false

var vaultName = toLower('${namePrefix}-${uniqueString(resourceGroup().id)}')

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: vaultName
  location: location
  tags: tags
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
    enablePurgeProtection: enablePurgeProtection ? true : null
    enableSoftDelete: true
  }
}

@description('URI of the key vault.')
output vaultUri string = keyVault.properties.vaultUri

@description('Resource ID of the key vault.')
output vaultId string = keyVault.id
