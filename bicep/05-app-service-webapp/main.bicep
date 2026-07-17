targetScope = 'resourceGroup'

@description('Prefix used to build resource names.')
param namePrefix string = 'webapp'

@description('Azure region for all resources.')
param location string = resourceGroup().location

@description('Tags applied to all resources.')
param tags object = {
  environment: 'dev'
  project: 'azure-iac-templates'
}

@description('App Service Plan SKU.')
param skuName string = 'B1'

var appServicePlanName = '${namePrefix}-plan'
var webAppName = toLower('${namePrefix}-${uniqueString(resourceGroup().id)}')

resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: appServicePlanName
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2023-12-01' = {
  name: webAppName
  location: location
  tags: tags
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'NODE|20-lts'
      minTlsVersion: '1.2'
    }
  }
}

@description('Default hostname of the web app.')
output defaultHostname string = webApp.properties.defaultHostName

@description('Resource ID of the web app.')
output appId string = webApp.id
