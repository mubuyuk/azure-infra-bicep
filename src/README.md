
# 1 Logga in i Azure
```shell
az login
```
# 2 Välj rätt subscription

## 3 Deployment till DEV-miljön # Sätter upp din miljön via main.bicep.
Kör först WHAT-IF (simulering):
```shell
az deployment group create   --resource-group <RESOURCE_GROUP_NAME_DEV>   --template-file .\src\main.bicep   --parameters '@.\src\parameters\dev.json'   --confirm-with-what-if
```
Efter WHAT-IF visas en förändringsplan (Create / Modify / Delete / Ignore).  
- Yes = deploya resurserna  
- No = avbryt  

Resurser som sätts upp i DEV:  
- App Service Plan (B1 enligt dev-parametrar)  
- Web App (HTTPS-only, med taggar: owner, environment, costCenter)  
- Storage Account (om deployStorage=true) – typ StorageV2, SKU Standard_LRS, unikt namn  
- Outputs: Web App-URL  

## 4 Deployment till TEST-miljön
```shell
az deployment group create   --resource-group <RESOURCE_GROUP_NAME_TEST>   --template-file .\src\main.bicep   --parameters '@.\src\parameters\test.json'   --confirm-with-what-if
```
Resurser i TEST:  
- Samma typer som i DEV (B1-plan, Web App, ev. Storage) men med -test- i namn  
- Outputs: Web App-URL för test  

## 5 Deployment till PROD-miljön
```shell
az deployment group create   --resource-group <RESOURCE_GROUP_NAME_PROD>   --template-file .\src\main.bicep   --parameters '@.\src\parameters\prod.json'   --confirm-with-what-if
```
Resurser i PROD:  
- App Service Plan (S1 enligt prod-parametrar)  
- Web App (HTTPS-only, taggar enligt parametrar)  
- Storage Account (om deployStorage=true)  
- Outputs: Web App-URL för prod  

## 6 Hämta outputs för ex. DEV (efter att resurserna är skapade)
Exempel för att bara få ut Web App-URL:
```shell
az deployment group create \
  --resource-group <RESOURCE_GROUP_NAME_DEV> \
  --template-file .\\src\\main.bicep \
  --parameters '@.\\src\\parameters\\dev.json' \
  --query "properties.outputs.webAppUrl.value" -o tsv
```

## Sammanfattning
- Använd --confirm-with-what-if för att granska förändringar innan deployment.  
- Välj Yes för att deploya eller No för att avbryta.  
- Resurserna som skapas beror på parametrarna i respektive fil (dev.json, test.json, prod.json).  
- Outputs innehåller bland annat den publika Web App-URL:en.
