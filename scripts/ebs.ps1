# Run AWS CLI command to describe volumes and capture the output
$volumesJson = aws ec2 describe-volumes --output json
$volumes = $volumesJson | ConvertFrom-Json

# Initialize an array to store the details of each volume
$volumeDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each volume
foreach ($volume in $volumes.Volumes) {
    $volumeName = $null
    if ($volume.Tags) {
        $volumeNameTag = $volume.Tags | Where-Object { $_.Key -eq 'Name' }
        if ($volumeNameTag) {
            $volumeName = $volumeNameTag.Value
        }
    }

    $attachedInstanceId = $null
    $deleteOnTermination = $null

    # Check if volume is attached
    if ($volume.Attachments.Count -gt 0) {
        $attachedInstanceId = $volume.Attachments[0].InstanceId
        $deleteOnTermination = $volume.Attachments[0].DeleteOnTermination
    }

    # Add details to the array
    $volumeDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Volume Name' = $volumeName
        'Volume ID' = $volume.VolumeId
        'Volume Type' = $volume.VolumeType
        'Size' = $volume.Size
        'Encryption' = $volume.Encrypted
        'Attached Instance ID' = $attachedInstanceId
        'DeleteOnTermination' = $deleteOnTermination
        'Availability Zone' = $volume.AvailabilityZone
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$volumeDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'EBS'