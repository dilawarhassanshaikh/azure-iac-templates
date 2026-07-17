targetScope = 'resourceGroup'

@description('Prefix used to build resource names.')
param namePrefix string = 'pg'

@description('Azure region for all resources.')
param location string = resourceGroup().location

@description('Tags applied to all resources.')
param tags object = {
  environment: 'dev'
  project: 'azure-iac-templates'
}

@description('PostgreSQL major version.')
param postgresVersion string = '16'

@description('SKU name for the flexible server.')
param skuName string = 'Standard_B1ms'

@description('Compute tier for the flexible server.')
param skuTier string = 'Burstable'

@description('Storage size in GB.')
param storageSizeGB int = 32

@description('Administrator login for the PostgreSQL server.')
param adminLogin string

@description('Administrator password for the PostgreSQL server.')
@secure()
param adminPassword string

@description('Name of the database to create.')
param databaseName string = 'appdb'

@description('Whether to add a firewall rule allowing other Azure services to reach the server.')
param allowAzureServices bool = true

var serverName = toLower('${namePrefix}-${uniqueString(resourceGroup().id)}')

resource postgresServer 'Microsoft.DBforPostgreSQL/flexibleServers@2022-12-01' = {
  name: serverName
  location: location
  tags: tags
  sku: {
    name: skuName
    tier: skuTier
  }
  properties: {
    version: postgresVersion
    administratorLogin: adminLogin
    administratorLoginPassword: adminPassword
    storage: {
      storageSizeGB: storageSizeGB
    }
    createMode: 'Default'
  }
}

resource postgresDatabase 'Microsoft.DBforPostgreSQL/flexibleServers/databases@2022-12-01' = {
  parent: postgresServer
  name: databaseName
  properties: {
    charset: 'UTF8'
    collation: 'en_US.utf8'
  }
}

resource allowAzureServicesRule 'Microsoft.DBforPostgreSQL/flexibleServers/firewallRules@2022-12-01' = if (allowAzureServices) {
  parent: postgresServer
  name: 'AllowAllAzureServicesAndResourcesWithinAzureIps'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

@description('Fully qualified domain name of the PostgreSQL server.')
output serverFqdn string = postgresServer.properties.fullyQualifiedDomainName

@description('Resource ID of the database.')
output databaseId string = postgresDatabase.id
