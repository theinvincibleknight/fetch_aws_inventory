# Run AWS CLI command to describe network interfaces and capture the output
$networkInterfacesJson = aws ec2 describe-network-interfaces --output json
$networkInterfaces = $networkInterfacesJson | ConvertFrom-Json

# Initialize an array to store the details of each network interface
$networkInterfaceDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each network interface
foreach ($interface in $networkInterfaces.NetworkInterfaces) {
    # Add details to the array
    $networkInterfaceDetails += [PSCustomObject]@{
        'Sr. No.'               = $serialNumber++
        'AttachmentId'          = $interface.Attachment.AttachmentId
        'DeleteOnTermination'   = $interface.Attachment.DeleteOnTermination
        'AttachmentStatus'      = $interface.Attachment.Status
        'AvailabilityZone'      = $interface.AvailabilityZone
        'Description'           = $interface.Description
        'Instance ID'           = $interface.Attachment.InstanceId
        'GroupName'             = ($interface.Groups | ForEach-Object { $_.GroupName }) -join ', '
        'GroupId'               = ($interface.Groups | ForEach-Object { $_.GroupId }) -join ', '
        'InterfaceType'         = $interface.InterfaceType
        'NetworkInterfaceId'    = $interface.NetworkInterfaceId
        'PrivateIpAddress'      = $interface.PrivateIpAddresses.PrivateIpAddress
        'VpcId'                 = $interface.VpcId
        'SubnetId'              = $interface.SubnetId
        'Status'                = $interface.Status
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$networkInterfaceDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'Network Interfaces'
