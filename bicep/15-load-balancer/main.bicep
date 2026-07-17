targetScope = 'resourceGroup'

@description('Prefix used to build resource names.')
param namePrefix string = 'lb'

@description('Azure region for all resources.')
param location string = resourceGroup().location

@description('Tags applied to all resources.')
param tags object = {
  environment: 'dev'
  project: 'azure-iac-templates'
}

@description('Port used for the TCP health probe.')
param probePort int = 80

@description('Frontend port for the load balancing rule.')
param frontendPort int = 80

@description('Backend port for the load balancing rule.')
param backendPort int = 80

var publicIpName = '${namePrefix}-pip'
var lbName = '${namePrefix}-lb'
var frontendName = 'LoadBalancerFrontend'
var backendPoolName = 'backendPool'
var probeName = 'httpProbe'

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

resource loadBalancer 'Microsoft.Network/loadBalancers@2023-11-01' = {
  name: lbName
  location: location
  tags: tags
  sku: {
    name: 'Standard'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: frontendName
        properties: {
          publicIPAddress: {
            id: publicIp.id
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: backendPoolName
      }
    ]
    probes: [
      {
        name: probeName
        properties: {
          protocol: 'Tcp'
          port: probePort
          intervalInSeconds: 15
          numberOfProbes: 2
        }
      }
    ]
    loadBalancingRules: [
      {
        name: 'lbrule'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', lbName, frontendName)
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', lbName, backendPoolName)
          }
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', lbName, probeName)
          }
          protocol: 'Tcp'
          frontendPort: frontendPort
          backendPort: backendPort
          idleTimeoutInMinutes: 4
        }
      }
    ]
  }
}

@description('Public IP address of the load balancer.')
output lbPublicIp string = publicIp.properties.ipAddress

@description('Resource ID of the load balancer.')
output lbId string = loadBalancer.id
