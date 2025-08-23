targetScope = 'resourceGroup'

param location  string
param environment string
param sku string
param tags object
param deployStorage bool = true

module storage './modules/storage.bicep' = {
  name : 'storage'
  params: {
    location: location
    sku: sku
    tags: tags
    environment: environment
    deployStorage: deployStorage
  }
}

output storageAccountName string = storage.outputs.storageAccountName
