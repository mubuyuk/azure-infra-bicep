targetScope = 'resourceGroup'

param location string               //region ex "swedencentral"
param environment string            // ex. test, dev, prod
param appServiceSku string          // prisplan ex. B1,
param tags object                   // taggas ex. owner: murat
param httpsOnly bool = true
param isLinux bool = true
param appServicePlanPrefix string
param webAppPrefix string

var appServiceName = '${appServicePlanPrefix}-${environment}'
var webAppName = toLower('${webAppPrefix}-${environment}-${uniqueString(resourceGroup().id)}')

resource appService 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: appServiceName
  location: location
  sku: {
    name: appServiceSku
  }
  properties: {
    reserved: isLinux
  }
  tags: tags
}


resource webApp 'Microsoft.Web/sites@2024-11-01' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: appService.id
    httpsOnly: httpsOnly
  }
  tags: tags
}

// skriv ut Web App URL.
output webAppUrl string = 'https://${webApp.properties.defaultHostName}'
output appServiceOut string = appService.name
output webAppNameOut string = webApp.name
output appServicePlanId string = appService.id
