param adminUsername string
param adminPassword string


module site0 'site.bicep' = {
  name: 'site0'
  params:  {
    adminPassword: adminPassword
    adminUsername: adminUsername
    num: 0
    location: 'westeurope'
  }
}

module site1 'site.bicep' = {
  name: 'site1'
  params:  {
    adminPassword: adminPassword
    adminUsername: adminUsername
    num: 1
    location: 'westeurope'
  }
}


module site2 'site.bicep' = {
  name: 'site2'
  params:  {
    adminPassword: adminPassword
    adminUsername: adminUsername
    num: 2
    location: 'northeurope'
  }
}


module peering 'peering.bicep' = {
  name: '0and1'
  params: {
    vnetOneName: site0.outputs.vnetName
    vnetOneId: site0.outputs.vnetId
    vnetTwoName: site1.outputs.vnetName
    vnetTwoId: site1.outputs.vnetId
  }
}

module peering1 'peering.bicep' = {
  name: '0and2'
  params: {
    vnetOneName: site0.outputs.vnetName
    vnetOneId: site0.outputs.vnetId
    vnetTwoName: site2.outputs.vnetName
    vnetTwoId: site2.outputs.vnetId
  }
}

module peering2 'peering.bicep' = {
  name: '1and2'
  params: {
    vnetOneName: site1.outputs.vnetName
    vnetOneId: site1.outputs.vnetId
    vnetTwoName: site2.outputs.vnetName
    vnetTwoId: site2.outputs.vnetId
  }
}
