targetScope = 'subscription'

param rgName string = 'rgazurebiceppoc'
param storageName string = uniqueString('stzurebiceppoc')

param location string
param teamsUsername string
@secure()
param teamsPassword string
@secure()
param appClientSecret string

resource rgazurebiceppoc 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: rgName
  location: location
}

// Deploy storage account
module stazurebiceppoc './storage.bicep' = {
  name: 'storageCreation'
  scope: rgazurebiceppoc
  params: {
    name: storageName
    location: location
  }
}

output storageAccountId string = stazurebiceppoc.outputs.storageAccountId

// Connect to Teams
module teams './teams.bicep' = {
  name: 'connectTeams'
  scope: rgazurebiceppoc
  params: {
    username: teamsUsername
    password: teamsPassword
    clientSecret: appClientSecret
    location: location
  }
}

