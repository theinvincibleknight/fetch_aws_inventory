# Run AWS CLI command to describe addresses and capture the output
$addressesJson = aws ec2 describe-addresses --output json
$addresses = $addressesJson | ConvertFrom-Json

# Initialize an array to store the details of each Elastic IP
$eipDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each Elastic IP
foreach ($address in $addresses.Addresses) {
    # Get Elastic IP details
    $name = $address.Tags | Where-Object { $_.Key -eq "Name" } | Select-Object -ExpandProperty Value

    # Add details to the array
    $eipDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Name' = $name
        'Allocated IPv4 Address' = $address.PublicIp
        'Type' = $address.Domain
        'Allocation ID' = $address.AllocationId
        'Associated with Instance ID' = $address.InstanceId
        'Private IP Address' = $address.PrivateIpAddress
        'Association ID' = $address.AssociationId
        'Region' = $address.NetworkBorderGroup
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$eipDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'EIP'