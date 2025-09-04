targetScope = 'resourceGroup'

param deployStorage bool = true
param location string
param tags object
param environment string
param storageSku string
param storageKind string

var storageNameBase = toLower('storageacc${environment}${uniqueString(resourceGroup().id)}')
var storageName = substring(storageNameBase, 0, 24)

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' = if (deployStorage) {
  name: storageName
  location: location
  sku: {
    name: storageSku
  }
  kind:  storageKind
  tags: tags
}

output storageAccountName string = storageAccount.name
