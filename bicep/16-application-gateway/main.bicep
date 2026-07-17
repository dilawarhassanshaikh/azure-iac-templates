targetScope = 'resourceGroup'

@description('Prefix used to build resource names.')
param namePrefix string = 'agw'

@description('Azure region for all resources.')
param location string = resourceGroup().location

@description('Tags applied to all resources.')
param tags object = {
  environment: 'dev'
  project: 'azure-iac-templates'
}

@description('SKU name/tier for the Application Gateway.')
param skuName string = 'WAF_v2'

@description('Minimum autoscale instance capacity.')
param autoscaleMinCapacity int = 1

@description('Maximum autoscale instance capacity.')
param autoscaleMaxCapacity int = 3

@description('Placeholder backend pool IP addresses (replace with your real backend targets).')
param backendIpAddresses array = [
  '10.30.2.4'
  '10.30.2.5'
]

@description('Address space for the Application Gateway virtual network.')
param vnetAddressPrefix string = '10.30.0.0/16'

@description('Address prefix for the Application Gateway subnet.')
param subnetAddressPrefix string = '10.30.1.0/24'

var vnetName = '${namePrefix}-vnet'
var subnetName = 'appgw-subnet'
var publicIpName = '${namePrefix}-pip'
var gatewayName = '${namePrefix}-gw'
var gatewayIpConfigName = 'appGatewayIpConfig'
var frontendIpConfigName = 'appGatewayFrontendIP'
var frontendPortName = 'port80'
var backendPoolName = 'backendPool'
var backendHttpSettingsName = 'backendHttpSettings'
var httpListenerName = 'httpListener'
var requestRoutingRuleName = 'routingRule'

resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetAddressPrefix
        }
      }
    ]
  }
}

resource publicIp 'Microsoft.Network/publicIPAddresses@2023-11-01' = {
  name: publicIpName
  location: location
  tags: tags
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource applicationGateway 'Microsoft.Network/applicationGateways@2023-11-01' = {
  name: gatewayName
  location: location
  tags: tags
  properties: {
    sku: {
      name: skuName
      tier: skuName
    }
    autoscaleConfiguration: {
      minCapacity: autoscaleMinCapacity
      maxCapacity: autoscaleMaxCapacity
    }
    gatewayIPConfigurations: [
      {
        name: gatewayIpConfigName
        properties: {
          subnet: {
            id: vnet.properties.subnets[0].id
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: frontendIpConfigName
        properties: {
          publicIPAddress: {
            id: publicIp.id
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: frontendPortName
        properties: {
          port: 80
        }
      }
    ]
    backendAddressPools: [
      {
        name: backendPoolName
        properties: {
          backendAddresses: [for ip in backendIpAddresses: {
            ipAddress: ip
          }]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: backendHttpSettingsName
        properties: {
          port: 80
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          requestTimeout: 30
        }
      }
    ]
    httpListeners: [
      {
        name: httpListenerName
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', gatewayName, frontendIpConfigName)
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', gatewayName, frontendPortName)
          }
          protocol: 'Http'
        }
      }
    ]
    requestRoutingRules: [
      {
        name: requestRoutingRuleName
        properties: {
          ruleType: 'Basic'
          priority: 100
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', gatewayName, httpListenerName)
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', gatewayName, backendPoolName)
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', gatewayName, backendHttpSettingsName)
          }
        }
      }
    ]
    webApplicationFirewallConfiguration: {
      enabled: true
      firewallMode: 'Prevention'
      ruleSetType: 'OWASP'
      ruleSetVersion: '3.2'
    }
  }
}

@description('Public IP address of the Application Gateway.')
output gatewayPublicIp string = publicIp.properties.ipAddress

@description('Resource ID of the Application Gateway.')
output gatewayId string = applicationGateway.id
