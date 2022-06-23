@minLength(1)
@maxLength(59)
param name string

resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: name
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
  }
}

output storageAccountId string = storageAccount.id
