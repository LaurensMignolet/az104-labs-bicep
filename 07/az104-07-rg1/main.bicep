param location string = resourceGroup().location

//Task 2
resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'az10407salm220529'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Cool'

    networkAcls: {
      defaultAction: 'Deny'
      ipRules: [
        {
          action: 'Allow'
          value: '12.123.123.123' // your ip
        }
      ]
    }

  }
}

//Task 3
resource blobservice 'Microsoft.Storage/storageAccounts/blobServices@2021-09-01' = {
  name: 'default'
  parent: storageaccount
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-09-01' = {
  name: 'az104-07-container'
  parent: blobservice

  properties: {
    publicAccess: 'None'
  }
}

//Task 5

resource fileservice 'Microsoft.Storage/storageAccounts/fileServices@2021-09-01' = {
  name: 'default'
  parent: storageaccount
}

resource fileshare 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-09-01' = {
  name: 'az104-07-share'
  parent: fileservice
}
