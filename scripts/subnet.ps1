# Run AWS CLI command to describe subnets and capture the output
$subnetsJson = aws ec2 describe-subnets --output json
$subnets = $subnetsJson | ConvertFrom-Json

# Initialize an array to store the details of each subnet
$subnetDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each subnet
foreach ($subnet in $subnets.Subnets) {
    # Get subnet details
    $subnetName = $subnet.Tags | Where-Object { $_.Key -eq "Name" } | Select-Object -ExpandProperty Value
    $subnetId = $subnet.SubnetId
    $vpcId = $subnet.VpcId
    $ipv4Cidr = $subnet.CidrBlock
    $availableIpv4Address = $subnet.AvailableIpAddressCount
    $availabilityZone = $subnet.AvailabilityZone
    # $routeTable = $subnet.RouteTableId
    $isDefault = $subnet.DefaultForAz
    $autoAssignPublicIp = $subnet.MapPublicIpOnLaunch

    # Check if the subnet has an internet gateway
    # $internetGateway = "None"
    # if ($subnet.Associations) {
    #     $internetGateway = $null -ne ($subnet.Associations | Where-Object { $_.Main })
    # }

    # Add details to the array
    $subnetDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Subnet_Name' = $subnetName
        'Subnet ID' = $subnetId
        'VPC' = $vpcId
        'IPv4 CIDR' = $ipv4Cidr
        'Available IPv4 Address' = $availableIpv4Address
        'Availability Zone' = $availabilityZone
        #'Route Table' = $routeTable
        'Default Subnet' = $isDefault
        'Auto Assign Public IP' = $autoAssignPublicIp
        #'Gateway' = $internetGateway
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$subnetDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'Subnet'