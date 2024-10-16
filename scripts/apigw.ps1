# Run AWS CLI command to list API Gateways and capture the output
$apiGatewaysJson = aws apigateway get-rest-apis --output json
$apiGateways = $apiGatewaysJson | ConvertFrom-Json

# Initialize an array to store the details of each API Gateway
$apiGatewayDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each API Gateway
foreach ($apiGateway in $apiGateways.items) {
    # Add details to the array
    $apiGatewayDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Name' = $apiGateway.name
        'Description' = $apiGateway.description
        'ID' = $apiGateway.id
        'API Endpoint Type' = $apiGateway.endpointConfiguration.types -join ', '
        'Created Time' = $apiGateway.createdDate
        #'Created Time' = [datetime]::FromFileTimeUtc($apiGateway.createdDate)
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$apiGatewayDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'API Gateway'