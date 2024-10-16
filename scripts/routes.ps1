# Run AWS CLI command to describe route tables and capture the output
$routeTablesJson = aws ec2 describe-route-tables --output json
$routeTables = $routeTablesJson | ConvertFrom-Json

# Initialize an array to store the details of each route table and its routes
$routeTableDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each AWS Route Table
foreach ($routeTable in $routeTables.RouteTables) {
    # Get AWS Route Table details
    $routeTableName = $routeTable.Tags | Where-Object { $_.Key -eq "Name" } | Select-Object -ExpandProperty Value
    $routeTableId = $routeTable.RouteTableId
    $vpcId = $routeTable.VpcId
    $region = $routeTable.Tags | Where-Object { $_.Key -eq "aws:cloudformation:stack-name" } | Select-Object -ExpandProperty Value

    # Iterate over routes in the route table
    foreach ($route in $routeTable.Routes) {
        $destinationCidrBlock = $route.DestinationCidrBlock
        $target = $route.GatewayId
        if (-not $target) {
            $target = $route.NatGatewayId
        }
        if (-not $target) {
            $target = $route.VpcPeeringConnectionId
        }
        if (-not $target) {
            $target = $route.NetworkInterfaceId
        }

        # Add details to the array
        $routeTableDetails += [PSCustomObject]@{
            'Sr. No.' = $serialNumber++
            'Route Table Name' = $routeTableName
            'Route Table ID' = $routeTableId
            'VPC ID' = $vpcId
            'Region' = $region
            'Destination CIDR Block' = $destinationCidrBlock
            'Target' = $target
        }
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$routeTableDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'Routes'