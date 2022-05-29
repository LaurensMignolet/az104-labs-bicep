$location = 'westeurope'

$rg0Name = 'az104-07-rg0'
$rg1Name = 'az104-07-rg1'

az group create --location $location --name $rg0Name
az group create --location $location --name $rg1Name

az group deployment create --resource-group $rg0Name --template-file $rg0Name'/main.bicep' 
az group deployment create --resource-group $rg1Name --template-file  $rg1Name'/main.bicep'
