targetScope = 'resourceGroup'

param deployStorage bool = true
param location string
param tags object
param environment string
param storageSku string

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' = if (deployStorage) {
  name: '${environment}${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: storageSku
  }
  kind: 'StorageV2'
  tags: tags
}

output storageAccountName string = storageAccount.name
