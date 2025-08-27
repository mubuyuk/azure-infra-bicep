targetScope = 'resourceGroup'

param location string                   // "swedencentral"
param environment string                // "dev" | "test" | "prod"
param tags object                       // { owner, environment, costCenter }

// Storage
param storageSku string                        // "Standard_LRS"
param deployStorage bool = true         // slå av/på storage-deploy

// App Service
param appServiceSku string                // "B1" (dev/test) eller "S1" (prod)
param httpsOnly bool = true             // OBS: namnet måste matcha din modul
param isLinux bool = false              // eller true, välj vad du kör

param appServicePlanPrefix string       // t.ex. "asp-"
param webAppPrefix string               // t.ex. "app-"


module storage './modules/storage.bicep' = {
  name : 'storage'
  params: {
    location: location
    storageSku: storageSku
    tags: tags
    environment: environment
    deployStorage: deployStorage
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
output webAppurl string = appsvc.outputs.webAppUrl

