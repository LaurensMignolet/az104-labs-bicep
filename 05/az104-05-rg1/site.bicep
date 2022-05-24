param location string

param adminUsername string
param adminPassword string
param vmSize string = 'Standard_D2s_v3'

param num int 

resource vnet 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'az104-05-vnet${num}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.5${num}.0.0/22'
      ]
    }
    subnets: [
      {
        name: 'Subnet0'
        properties: {
          addressPrefix: '10.5${num}.0.0/24'
        }
      }
    ]
  }
}

resource pip 'Microsoft.Network/publicIPAddresses@2019-11-01' =  {
  name: 'az104-05-pip${num}'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'

  }
}


resource nsg01 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: 'az104-05-nsg${num}'
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


resource nic 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: 'az104-05-nic${num}'
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
            id: vnet.properties.subnets[0].id
          }

          publicIPAddress: {
            id: pip.id
          }          
        }
      }
    ]
  }
}


resource vms 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: 'az104-05-vm${num}'
  location: location
  properties: {
    osProfile: {
      computerName: 'az104-05-vm${num}'
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
          id: nic.id
        }
      ]
    }
  }
}

output vnetName string = vnet.name
output vnetId string = vnet.id
