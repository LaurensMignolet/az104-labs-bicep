param vnetOneName string
param vnetOneId string
param vnetTwoName string
param vnetTwoId string


resource peeringTo 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-07-01' = {
  name: '${vnetOneName}/${vnetOneName}_to_${vnetTwoName}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnetTwoId
    }
  }
}

resource peeringBack 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-07-01' = {
  name: '${vnetTwoName}/${vnetTwoName}_to_${vnetOneName}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnetOneId
    }
  }
}
