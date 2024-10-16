# Run AWS CLI command to describe VPC endpoints and capture the output
$endpointsJson = aws ec2 describe-vpc-endpoints --output json
$endpoints = $endpointsJson | ConvertFrom-Json

# Initialize an array to store the details of each VPC Endpoint
$endpointDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each VPC Endpoint
foreach ($endpoint in $endpoints.VpcEndpoints) {
    
    # Add details to the array
    $endpointDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Name' = $endpoint.Tags | Where-Object { $_.Key -eq "Name" } | Select-Object -ExpandProperty Value
        'VPC endpoint ID' = $endpoint.VpcEndpointId
        'VPC ID' = $endpoint.VpcId
        'Service name' = $endpoint.ServiceName
        'Endpoint type' = $endpoint.VpcEndpointType
        'Network interfaces' = $endpoint.NetworkInterfaceIds -join ","
        'Subnets' = $endpoint.SubnetIds -join ","
        'Route tables' = $endpoint.RouteTableIds -join ","
        #'Region' = $region
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$endpointDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'Endpoints'