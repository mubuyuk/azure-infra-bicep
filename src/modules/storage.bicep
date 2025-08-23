targetScope = 'resourceGroup'

param deployStorage bool = true
param location string
param tags object
param environment string
param sku string

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' = if (deployStorage) {
  name: '${environment}${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: sku
  }
  kind: 'StorageV2'
  tags: tags
}

output storageAccountName string = storageAccount.name
