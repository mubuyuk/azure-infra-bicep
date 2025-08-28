targetScope = 'resourceGroup'

param location string                   // "swedencentral"
param environment string                // "dev" | "test" | "prod"
param tags object                       // { owner, environment, costCenter }
param storageKind string

// Storage
param storageSku string                        // "Standard_LRS"
param deployStorage bool = true         // slå av/på storage-deploy

// App Service
param appServiceSku string                // "B1" (dev/test) eller "S1" (prod)
param httpsOnly bool = true             
param isLinux bool = false

param appServicePlanPrefix string
param webAppPrefix string

module storage './modules/storage.bicep' = {
  name : 'storage'
  params: {
    location: location
    storageSku: storageSku
    tags: tags
    environment: environment
    deployStorage: deployStorage
    storageKind: storageKind
  }
}


// App Service ( Webapp + ServicePlan i samma modul)
module appsvc './modules/appservice.bicep' = {
  name: 'appsvc'
  params: {
    location: location
    environment: environment
    appServiceSku: appServiceSku
    tags: tags
    httpsOnly: httpsOnly
    isLinux: isLinux
    appServicePlanPrefix: appServicePlanPrefix
    webAppPrefix: webAppPrefix
  }
}

output storageAccountName string = storage.outputs.storageAccountName
output webAppUrl string = appsvc.outputs.webAppUrl

