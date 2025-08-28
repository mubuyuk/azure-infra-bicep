// Allt i denna modul skapas i en befintlig Resource Group
targetScope = 'resourceGroup'

//region ex "swedencentral"
param location string

// ex. test, dev, prod
param environment string

// prisplan ex. B1,
param appServiceSku string

// taggas ex. owner: murat
param tags object

param httpsOnly bool = true
param isLinux bool = true

param appServicePlanPrefix string
param webAppPrefix string

var appServiceName = '${appServicePlanPrefix}-${environment}'
var webAppName = toLower('${webAppPrefix}-${environment}-${uniqueString(resourceGroup().id)}')


// lokalt namn, kräver inte globalt unikt namn
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
