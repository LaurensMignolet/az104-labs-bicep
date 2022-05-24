$rg = 'az104-04-rg1'
$loc = 'westeurope'

az group create --location $loc --name $rg
az group deployment create --resource-group $rg --template-file 'main.bicep' --parameters 'parameters.json' 