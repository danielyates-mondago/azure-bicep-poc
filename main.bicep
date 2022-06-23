param rgName string = 'rgazurebiceppoc'
param storageName string = uniqueString('stzurebiceppoc')

param teamsUsername string
@secure()
param teamsPassword string
@secure()
param appClientSecret string

param location string = resourceGroup().location

// Deploy storage account
module stazurebiceppoc './storage.bicep' = {
  name: 'storageCreation'
  params: {
    name: storageName
    location: location
  }
}

output storageAccountId string = stazurebiceppoc.outputs.storageAccountId

// Connect to Teams
module teams './teams.bicep' = {
  name: 'connectTeams'
  params: {
    username: teamsUsername
    password: teamsPassword
    clientSecret: appClientSecret
    location: location
  }
}

