param location string = resourceGroup().location

param adminUsername string
param adminPassword string
param vmSize string = 'Standard_D2s_v3'

param numberOfVMs int = 2


resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'az104-04-vnet1'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.40.0.0/20'
      ]
    }
    subnets: [for i in range(0, numberOfVMs) : {
        name: 'Subnet${i}'
        properties: {
          addressPrefix: '10.40.${i}.0/24'
        }
      }]
  }
}

resource publicIPAddresses 'Microsoft.Network/publicIPAddresses@2019-11-01' = [for i in range(0, numberOfVMs): {
  name: 'az104-04-pip${i}'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'

  }
}]




resource nsg01 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: 'az104-04-nsg01'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowRDPInBound'
        properties: {
          description: 'Allow RDP'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource nics 'Microsoft.Network/networkInterfaces@2020-11-01' = [for i in range(0, numberOfVMs): {
  name: 'az104-04-nic${i}'
  location: location
  properties: {
    networkSecurityGroup: {
      id: nsg01.id
    }
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetwork.properties.subnets[i].id
          }

          publicIPAddress: {
            id: publicIPAddresses[i].id
          }          
        }
      }
    ]
  }
}]

resource vms 'Microsoft.Compute/virtualMachines@2021-11-01' = [for i in range(0, numberOfVMs): {
  name: 'az104-04-vm${i}'
  location: location
  properties: {
    osProfile: {
      computerName: 'az104-04-vm${i}'
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
      }
    }

    hardwareProfile: {
      vmSize: vmSize
    }

    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
      dataDisks: []
    }

    networkProfile: {
      networkInterfaces: [
        {
          properties: {
            primary: true
          }
          id: nics[i].id
        }
      ]
    }
  }
}]


resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'contoso.org'
  location: 'global'

}

resource vnetDnsLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'az104-04-vnet1-link'
  location: 'global'
  parent: privateDnsZone
  properties: {
    registrationEnabled: true
    virtualNetwork: {
      id: virtualNetwork.id
    }
  }
}

//contosocorp20220524

resource dns 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: 'contosocorp20220524.com'
  location: 'global'
}

resource record 'Microsoft.Network/dnsZones/A@2018-05-01' = [for i in range(0, numberOfVMs): {
  parent: dns
  name: 'az104-04-vm${i}'
  properties: {
    TTL: 3600
    ARecords: [
      {
        ipv4Address: publicIPAddresses[i].properties.ipAddress
      }
    ]
  }
}]
