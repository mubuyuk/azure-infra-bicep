targetScope = 'resourceGroup'

param location string                   // "region swedencentral"
param environment string                //  dev/test/prod
param tags object                       //  owner, environment, costCenter
param storageKind string                //  kravet: "StorageV2"

// Storage
param storageSku string                 // kravet: "Standard_LRS"
param deployStorage bool = true         // slå av/på storage-deploy

// App Service
param appServiceSku string                // "B1" (dev/test) eller "S1" (prod)
param httpsOnly bool = true             
param isLinux bool = true

param appServicePlanPrefix string         //Prefix för App Service Plan, "myAppPlan"
param webAppPrefix string                 //('Prefix för Web App, "mywebapp"')

module storage './modules/storage.bicep' = {
  name : 'storage-${environment}'
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

