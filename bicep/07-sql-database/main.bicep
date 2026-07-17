targetScope = 'resourceGroup'

@description('Prefix used to build resource names.')
param namePrefix string = 'sql'

@description('Azure region for all resources.')
param location string = resourceGroup().location

@description('Tags applied to all resources.')
param tags object = {
  environment: 'dev'
  project: 'azure-iac-templates'
}

@description('Administrator login for the SQL logical server.')
param adminLogin string

@description('Administrator password for the SQL logical server.')
@secure()
param adminPassword string

@description('SKU name for the SQL database.')
param skuName string = 'Basic'

@description('Name of the database to create.')
param databaseName string = 'appdb'

@description('Whether to add a firewall rule allowing other Azure services to reach the server.')
param allowAzureServices bool = true

var sqlServerName = toLower('${namePrefix}-${uniqueString(resourceGroup().id)}')

resource sqlServer 'Microsoft.Sql/servers@2021-11-01' = {
  name: sqlServerName
  location: location
  tags: tags
  properties: {
    administratorLogin: adminLogin
    administratorLoginPassword: adminPassword
    version: '12.0'
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-11-01' = {
  parent: sqlServer
  name: databaseName
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  properties: {}
}

resource allowAzureServicesRule 'Microsoft.Sql/servers/firewallRules@2021-11-01' = if (allowAzureServices) {
  parent: sqlServer
  name: 'AllowAllWindowsAzureIps'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

@description('Fully qualified domain name of the SQL server.')
output sqlServerFqdn string = sqlServer.properties.fullyQualifiedDomainName

@description('Resource ID of the SQL database.')
output databaseId string = sqlDatabase.id
