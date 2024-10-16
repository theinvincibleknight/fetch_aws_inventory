# Run AWS CLI command to describe NAT gateways and capture the output
$natGatewaysJson = aws ec2 describe-nat-gateways --output json
$natGateways = $natGatewaysJson | ConvertFrom-Json

# Initialize an array to store the details of each NAT gateway
$natGatewayDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each NAT gateway
foreach ($natGateway in $natGateways.NatGateways) {
    # Get NAT gateway details
    $natGatewayName = $natGateway.Tags | Where-Object { $_.Key -eq "Name" } | Select-Object -ExpandProperty Value
    $natGatewayId = $natGateway.NatGatewayId
    ### $connectivityType = $natGateway.NatGatewayAddresses[0].NetworkInterfaceId -eq $null ? "Public IP" : "Elastic IP"
    # $connectivityType = if ($null -eq $natGateway.NatGatewayAddresses[0].NetworkInterfaceId) {
    #     "Public IP"
    # } else {
    #     "Elastic IP"
    # }
    
    $connectivityType = $natGateway.ConnectivityType
    $publicIpAddress = $natGateway.NatGatewayAddresses[0].PublicIp
    $privateIpAddress = $natGateway.NatGatewayAddresses[0].PrivateIp
    $networkInterfaceId = $natGateway.NatGatewayAddresses[0].NetworkInterfaceId
    $vpcId = $natGateway.VpcId
    $subnetId = $natGateway.SubnetId
    # $region = $natGateways.ResponseMetadata.RequestId.Split('.')[1]

    # Add details to the array
    $natGatewayDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Name' = $natGatewayName
        'NAT Gateway' = $natGatewayId
        'Connectivity Type' = $connectivityType
        'Primary public IPv4 address' = $publicIpAddress
        'Primary private IPv4 address' = $privateIpAddress
        'Primary Network interface ID' = $networkInterfaceId
        'VPC' = $vpcId
        'Subnet' = $subnetId
        #'Region' = $region
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$natGatewayDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'NATGW'
