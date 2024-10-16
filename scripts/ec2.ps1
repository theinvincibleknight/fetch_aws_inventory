# Run AWS CLI command to describe instances and capture the output
$instancesJson = aws ec2 describe-instances --output json
$instances = $instancesJson | ConvertFrom-Json

# Initialize an array to store the details of each instance
$instanceDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each reservation (group of instances)
foreach ($reservation in $instances.Reservations) {
    # Iterate over each instance in the reservation
    foreach ($instance in $reservation.Instances) {
        # Get additional details for each instance and increment serial number
        $instanceDetails += [PSCustomObject]@{
            'Sr. No' = $serialNumber++
            InstanceId = $instance.InstanceId
            InstanceName = ($instance.Tags | Where-Object {$_.Key -eq 'Name'}).Value
            InstanceState = $instance.State.Name
            InstanceType = $instance.InstanceType
            AvailabilityZone = $instance.Placement.AvailabilityZone
            PublicIpAddress = $instance.PublicIpAddress
            ElasticIp = $instance.NetworkInterfaces.PrivateIpAddresses.Association.PublicIp
            PrivateIpAddress = $instance.PrivateIpAddress
            VpcId = $instance.VpcId
            SubnetId = $instance.SubnetId
            VolumeId = $instance.BlockDeviceMappings.Ebs.VolumeId -join ','
            VolumeSize = ($instance.BlockDeviceMappings | ForEach-Object {aws ec2 describe-volumes --volume-ids $_.Ebs.VolumeId --query "Volumes[].Size" --output text}).Trim()
            SecurityGroupName = ($instance.SecurityGroups | Select-Object -ExpandProperty GroupName) -join ','
            SecurityGroupId = ($instance.SecurityGroups | Select-Object -ExpandProperty GroupId) -join ','
            KeyName = $instance.KeyName
        }
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$instanceDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'EC2'