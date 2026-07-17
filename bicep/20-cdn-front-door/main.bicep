targetScope = 'resourceGroup'

@description('Prefix used to build resource names.')
param namePrefix string = 'afd'

@description('Azure region for all resources. Front Door is a global service; this only affects the resource metadata location.')
param location string = resourceGroup().location

@description('Tags applied to all resources.')
param tags object = {
  environment: 'dev'
  project: 'azure-iac-templates'
}

@description('SKU name for the Front Door profile.')
param skuName string = 'Standard_AzureFrontDoor'

@description('Hostname of the origin (e.g. an App Service default hostname or a public load balancer FQDN).')
param originHostName string

var profileName = '${namePrefix}-profile'
var endpointName = toLower('${namePrefix}-${uniqueString(resourceGroup().id)}')
var originGroupName = 'default-origin-group'
var originName = 'default-origin'
var routeName = 'default-route'

resource frontDoorProfile 'Microsoft.Cdn/profiles@2024-02-01' = {
  name: profileName
  location: 'global'
  tags: tags
  sku: {
    name: skuName
  }
}

resource afdEndpoint 'Microsoft.Cdn/profiles/afdEndpoints@2024-02-01' = {
  parent: frontDoorProfile
  name: endpointName
  location: 'global'
  tags: tags
  properties: {
    enabledState: 'Enabled'
  }
}

resource originGroup 'Microsoft.Cdn/profiles/originGroups@2024-02-01' = {
  parent: frontDoorProfile
  name: originGroupName
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
      additionalLatencyInMilliseconds: 50
    }
    healthProbeSettings: {
      probePath: '/'
      probeRequestType: 'HEAD'
      probeProtocol: 'Https'
      probeIntervalInSeconds: 100
    }
  }
}

resource origin 'Microsoft.Cdn/profiles/originGroups/origins@2024-02-01' = {
  parent: originGroup
  name: originName
  properties: {
    hostName: originHostName
    originHostHeader: originHostName
    httpPort: 80
    httpsPort: 443
    priority: 1
    weight: 1000
    enabledState: 'Enabled'
  }
}

resource route 'Microsoft.Cdn/profiles/afdEndpoints/routes@2024-02-01' = {
  parent: afdEndpoint
  name: routeName
  properties: {
    originGroup: {
      id: originGroup.id
    }
    supportedProtocols: [
      'Http'
      'Https'
    ]
    patternsToMatch: [
      '/*'
    ]
    forwardingProtocol: 'HttpsOnly'
    linkToDefaultDomain: 'Enabled'
    httpsRedirect: 'Enabled'
  }
  dependsOn: [
    origin
  ]
}

@description('Hostname of the Front Door endpoint.')
output frontDoorEndpointHostname string = afdEndpoint.properties.hostName
