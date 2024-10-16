# Run AWS CLI command to describe RDS instances and capture the output
$rdsInstancesJson = aws rds describe-db-instances --output json
$rdsInstances = $rdsInstancesJson | ConvertFrom-Json

# Initialize an array to store the details of each RDS instance
$rdsDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each RDS instance
foreach ($rdsInstance in $rdsInstances.DBInstances) {
    # Get VPC information
    # $vpcId = $rdsInstance.DBSubnetGroup.VpcId

    # Get subnet information
    # $subnets = $rdsInstance.DBSubnetGroup.Subnets | ForEach-Object { $_.SubnetIdentifier } -join ','

    # Get security group information
    # $securityGroups = $rdsInstance.VpcSecurityGroups | ForEach-Object { $_.VpcSecurityGroupId } -join ','

    # Add details to the array
    $rdsDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'DB Identifier' = $rdsInstance.DBInstanceIdentifier
        'Endpoint' = $rdsInstance.Endpoint.Address
        'Port' = $rdsInstance.Endpoint.Port
        # 'Role' = $rdsInstance.ReadReplicaSourceDBInstanceIdentifier
        'Engine' = $rdsInstance.Engine
        'EngineVersion' = $rdsInstance.EngineVersion
        'PubliclyAccessible' = $rdsInstance.PubliclyAccessible
        'DBInstanceClass' = $rdsInstance.DBInstanceClass
        'AllocatedStorage' = $rdsInstance.AllocatedStorage
        'VPC' = $rdsInstance.DBSubnetGroup.VpcId
        'Subnets' = $rdsInstance.DBSubnetGroup.Subnets.SubnetIdentifier -join ","
        'MultiAZ' = $rdsInstance.MultiAZ
        'Security Group' = $rdsInstance.VpcSecurityGroups.VpcSecurityGroupId -join ","
        'DBParameterGroupName' = $rdsInstance.DBParameterGroups.DBParameterGroupName
        # 'Auto Backup' = $rdsInstance.BackupRetentionPeriod
        'BackupRetentionPeriod' = $rdsInstance.BackupRetentionPeriod
        'AvailabilityZone' = $rdsInstance.AvailabilityZone
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$rdsDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'RDS'