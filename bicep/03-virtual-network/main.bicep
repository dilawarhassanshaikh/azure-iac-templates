targetScope = 'resourceGroup'

@description('Prefix used to build resource names.')
param namePrefix string = 'vnet'

@description('Azure region for all resources.')
param location string = resourceGroup().location

@description('Tags applied to all resources.')
param tags object = {
  environment: 'dev'
  project: 'azure-iac-templates'
}

@description('Address space for the virtual network.')
param addressSpace array = [
  '10.0.0.0/16'
]

@description('Address prefix for the web subnet.')
param webSubnetPrefix string = '10.0.1.0/24'

@description('Address prefix for the app subnet.')
param appSubnetPrefix string = '10.0.2.0/24'

@description('Address prefix for the data subnet.')
param dataSubnetPrefix string = '10.0.3.0/24'

var vnetName = '${namePrefix}-vnet'

resource webNsg 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: '${namePrefix}-web-nsg'
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'AllowHTTPHTTPS'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRanges: [
            '80'
            '443'
          ]
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource appNsg 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: '${namePrefix}-app-nsg'
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'AllowFromWebSubnet'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: webSubnetPrefix
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource dataNsg 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: '${namePrefix}-data-nsg'
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'AllowFromAppSubnet'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: appSubnetPrefix
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: addressSpace
    }
    subnets: [
      {
        name: 'web'
        properties: {
          addressPrefix: webSubnetPrefix
          networkSecurityGroup: {
            id: webNsg.id
          }
        }
      }
      {
        name: 'app'
        properties: {
          addressPrefix: appSubnetPrefix
          networkSecurityGroup: {
            id: appNsg.id
          }
        }
      }
      {
        name: 'data'
        properties: {
          addressPrefix: dataSubnetPrefix
          networkSecurityGroup: {
            id: dataNsg.id
          }
        }
      }
    ]
  }
}

@description('Resource ID of the virtual network.')
output vnetId string = vnet.id

@description('Map of subnet name to subnet resource ID.')
output subnetIds object = {
  web: vnet.properties.subnets[0].id
  app: vnet.properties.subnets[1].id
  data: vnet.properties.subnets[2].id
}
