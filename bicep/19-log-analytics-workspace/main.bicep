targetScope = 'resourceGroup'

@description('Prefix used to build resource names.')
param namePrefix string = 'log'

@description('Azure region for all resources.')
param location string = resourceGroup().location

@description('Tags applied to all resources.')
param tags object = {
  environment: 'dev'
  project: 'azure-iac-templates'
}

@description('Number of days to retain data in the workspace.')
param retentionInDays int = 30

var workspaceName = '${namePrefix}-law'
var appInsightsName = '${namePrefix}-appi'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: workspaceName
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: retentionInDays
  }
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  tags: tags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

@description('Resource ID of the Log Analytics workspace.')
output workspaceId string = logAnalyticsWorkspace.id

@description('Instrumentation key of the Application Insights component.')
output instrumentationKey string = appInsights.properties.InstrumentationKey
