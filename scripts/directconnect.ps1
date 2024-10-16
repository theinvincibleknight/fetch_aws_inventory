# Run AWS CLI command to describe Direct Connect connections and capture the output
$connectionsJson = aws directconnect describe-connections --output json
$connections = $connectionsJson | ConvertFrom-Json

# Initialize an array to store the details of each Direct Connect connection
$connectionDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each Direct Connect connection
foreach ($connection in $connections.connections) {

    # Add details to the array
    $connectionDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Connection ID' = $connection.connectionId
        'Name' = $connection.connectionName
        'Location' = $connection.location
        'Bandwidth' = $connection.bandwidth
        'Partner' = $connection.partnerName
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$connectionDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'DX'