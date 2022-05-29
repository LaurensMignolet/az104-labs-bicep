param location string = resourceGroup().location


resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'az104-07-vnet0'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.70.0.0/22'
      ]
    }
    subnets: [
      {
        name: 'Subnet0'
        properties: {
          addressPrefix: '10.70.0.0/24'
        }
      }
    ]
  }
}

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: 'az104-07-pip0'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}


resource networkInterface 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: 'az104-07-nic0'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetwork.properties.subnets[0].id
          }

          publicIPAddress: {
              id: publicIPAddress.id
          }
        }
      }
    ]
  }
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: 'az104-07-nic'
  location: location
  properties: {
    securityRules: [
      {
        name: 'default-Allow-rdp'
        properties: {
          priority: 1000
          sourceAddressPrefix: '*'
          protocol: 'Tcp'
          destinationPortRange: '3389'
          access: 'Allow'
          direction: 'Inbound'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}


resource windowsVM 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: 'az104-07-vm0'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_A2_v2'
    }
    osProfile: {
      computerName: 'az104-07-vm0'
      adminUsername: 'Student'
      adminPassword: 'Pa55w.rd1234'
      windowsConfiguration: {
        provisionVMAgent: true
      }
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
    }
    networkProfile: {
      networkInterfaces: [
        {
          properties: {
            primary: true
          }
          id: networkInterface.id
        }
      ]
    }
  }
}
