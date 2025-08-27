# 1 Logga in i Azure
az login

# 2 Välj rätt subscription

# Sätter upp DEV-miljön via main.bicep + parameters/dev.json
# Kör först WHAT-IF (simulering).
az deployment group create --resource-group RG-muratbuyuksal --template-file .\src\main.bicep --parameters '@.\src\parameters\dev.json' --confirm-with-what-if