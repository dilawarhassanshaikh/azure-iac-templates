targetScope = 'resourceGroup'

@description('Prefix used to build resource names.')
param namePrefix string = 'vmss'

@description('Azure region for all resources.')
param location string = resourceGroup().location

@description('Tags applied to all resources.')
param tags object = {
  environment: 'dev'
  project: 'azure-iac-templates'
}

@description('Number of VM instances in the scale set.')
param instanceCount int = 2

@description('Size of each VM instance.')
param vmSize string = 'Standard_B2s'

@description('Admin username for the VM instances.')
param adminUsername string = 'azureuser'

@description('SSH public key used for authentication (e.g. contents of ~/.ssh/id_rsa.pub).')
param sshPublicKey string

@description('Address space for the virtual network.')
param vnetAddressPrefix string = '10.40.0.0/16'

@description('Address prefix for the scale set subnet.')
param subnetAddressPrefix string = '10.40.1.0/24'

var vnetName = '${namePrefix}-vnet'
var subnetName = 'default'
var publicIpName = '${namePrefix}-pip'
var lbName = '${namePrefix}-lb'
var frontendName = 'LoadBalancerFrontend'
var backendPoolName = 'backendPool'
var probeName = 'httpProbe'
var natPoolName = 'sshNatPool'
var vmssName = '${namePrefix}-vmss'

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
          port: 80
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
          frontendPort: 80
          backendPort: 80
          idleTimeoutInMinutes: 4
        }
      }
    ]
    inboundNatPools: [
      {
        name: natPoolName
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', lbName, frontendName)
          }
          protocol: 'Tcp'
          frontendPortRangeStart: 50000
          frontendPortRangeEnd: 50019
          backendPort: 22
        }
      }
    ]
  }
}

resource vmss 'Microsoft.Compute/virtualMachineScaleSets@2024-03-01' = {
  name: vmssName
  location: location
  tags: tags
  sku: {
    name: vmSize
    tier: 'Standard'
    capacity: instanceCount
  }
  properties: {
    overprovision: false
    upgradePolicy: {
      mode: 'Manual'
    }
    virtualMachineProfile: {
      osProfile: {
        computerNamePrefix: namePrefix
        adminUsername: adminUsername
        linuxConfiguration: {
          disablePasswordAuthentication: true
          ssh: {
            publicKeys: [
              {
                path: '/home/${adminUsername}/.ssh/authorized_keys'
                keyData: sshPublicKey
              }
            ]
          }
        }
      }
      storageProfile: {
        imageReference: {
          publisher: 'Canonical'
          offer: '0001-com-ubuntu-server-jammy'
          sku: '22_04-lts-gen2'
          version: 'latest'
        }
        osDisk: {
          createOption: 'FromImage'
          managedDisk: {
            storageAccountType: 'Premium_LRS'
          }
        }
      }
      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: '${namePrefix}-nic'
            properties: {
              primary: true
              ipConfigurations: [
                {
                  name: '${namePrefix}-ipconfig'
                  properties: {
                    subnet: {
                      id: vnet.properties.subnets[0].id
                    }
                    loadBalancerBackendAddressPools: [
                      {
                        id: loadBalancer.properties.backendAddressPools[0].id
                      }
                    ]
                    loadBalancerInboundNatPools: [
                      {
                        id: loadBalancer.properties.inboundNatPools[0].id
                      }
                    ]
                  }
                }
              ]
            }
          }
        ]
      }
    }
  }
}

@description('Public IP address of the load balancer fronting the scale set.')
output lbPublicIp string = publicIp.properties.ipAddress

@description('Resource ID of the virtual machine scale set.')
output vmssId string = vmss.id
