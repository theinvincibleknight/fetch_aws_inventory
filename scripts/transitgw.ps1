# Run AWS CLI command to describe Transit Gateways and capture the output
$transitGatewaysJson = aws ec2 describe-transit-gateways --output json
$transitGateways = $transitGatewaysJson | ConvertFrom-Json

# Initialize an array to store the details of each Transit Gateway
$transitGatewayDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each Transit Gateway
foreach ($transitGateway in $transitGateways.TransitGateways) {
    # Get Transit Gateway details
    $transitGatewayId = $transitGateway.TransitGatewayId
    $transitGatewayName = $transitGateway.Tags | Where-Object { $_.Key -eq "Name" } | Select-Object -ExpandProperty Value
    $state = $transitGateway.State
    $ownerId = $transitGateway.OwnerId
    $description = $transitGateway.Description
    # $region = $transitGateway.Tags | Where-Object { $_.Key -eq "aws:cloudformation:stack-name" } | Select-Object -ExpandProperty Value
    $region = $transitGateway.TransitGatewayArn.Split(':')[3]

    # Add details to the array
    $transitGatewayDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Transit Gateway ID' = $transitGatewayId
        'Name' = $transitGatewayName
        'State' = $state
        'Owner ID' = $ownerId
        'Description' = $description
        'Region' = $region
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$transitGatewayDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'TGW'