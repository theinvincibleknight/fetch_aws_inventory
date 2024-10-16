# Run AWS CLI command to describe route tables and capture the output
$routeTablesJson = aws ec2 describe-route-tables --output json
$routeTables = $routeTablesJson | ConvertFrom-Json

# Initialize an array to store the details of each AWS Route Table
$routeTableDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each AWS Route Table
foreach ($routeTable in $routeTables.RouteTables) {
    # Get AWS Route Table details
    $name = $routeTable.Tags | Where-Object { $_.Key -eq "Name" } | Select-Object -ExpandProperty Value
    $routeTableId = $routeTable.RouteTableId
    $subnetAssociations = $routeTable.Associations.SubnetId -join ","
    # $isMain = $routeTable.Associations.AssociationId -contains "rtbassoc-main"
    $isMain = $routeTable.Associations.Main 
    $vpc = $routeTable.VpcId
    # $region = $routeTable.Tags | Where-Object { $_.Key -eq "aws:cloudformation:stack-name" } | Select-Object -ExpandProperty Value

    # Add details to the array
    $routeTableDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Name' = $name
        'Route Table ID' = $routeTableId
        'Subnet Associations' = $subnetAssociations
        'Main' = $isMain
        'VPC' = $vpc
        # 'Region' = $region
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$routeTableDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'RT'