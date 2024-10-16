# Run AWS CLI command to describe EFS file systems and capture the output
$efsJson = aws efs describe-file-systems --output json
$efs = $efsJson | ConvertFrom-Json

# Initialize an array to store the details of each EFS file system
$efsDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each EFS file system
foreach ($efsSystem in $efs.FileSystems) {
    # Get file system tags
    $name = $null
    if ($efsSystem.Tags) {
        $nameTag = $efsSystem.Tags | Where-Object { $_.Key -eq 'Name' }
        if ($nameTag) {
            $name = $nameTag.Value
        }
    }

    # Get VPC and subnet information
    # $vpcId = $efsSystem.VpcId
    # $subnetId = $efsSystem.SubnetId

    # Get IP address information
    # $ipAddress = $efsSystem.Endpoint

    # Get security group information
    # $securityGroup = $efsSystem.SecurityGroups -join ','

    # Add details to the array
    $efsDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Name' = $name
        'File System ID' = $efsSystem.FileSystemId
        'Total Size' = $efsSystem.SizeInBytes.Value
        'Availability Zone' = $efsSystem.AvailabilityZoneName
        #'VPC' = $vpcId
        #'Subnet' = $subnetId
        #'IP Address' = $ipAddress
        #'Security Group' = $securityGroup
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$efsDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'EFS'