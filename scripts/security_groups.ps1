# Run AWS CLI command to describe security groups and capture the output
$securityGroupsJson = aws ec2 describe-security-groups --output json
$securityGroups = $securityGroupsJson | ConvertFrom-Json

# Initialize an array to store the details of each security group
$securityGroupDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each security group
foreach ($securityGroup in $securityGroups.SecurityGroups) {
    # Iterate over ingress rules
    foreach ($ingressRule in $securityGroup.IpPermissions) {
        $securityGroupDetails += [PSCustomObject]@{
            'Sr. No' = $serialNumber++
            'Security Group ID' = $securityGroup.GroupId
            'Security Group Name' = $securityGroup.GroupName
            'Traffic Type' = 'Inbound'
            Protocol = $ingressRule.IpProtocol
            Port = $ingressRule.FromPort
            'Source IP' = ($ingressRule.IpRanges | Select-Object -ExpandProperty CidrIp) -join ','
            'Destination IP' = $null  # Not applicable for ingress
            Region = $ingressRule.Region
        }
    }

    # Iterate over egress rules
    foreach ($egressRule in $securityGroup.IpPermissionsEgress) {
        $securityGroupDetails += [PSCustomObject]@{
            'Sr. No' = $serialNumber++
            'Security Group ID' = $securityGroup.GroupId
            'Security Group Name' = $securityGroup.GroupName
            'Traffic Type' = 'Outbound'
            Protocol = $egressRule.IpProtocol
            Port = $egressRule.FromPort
            'Source IP' = $null  # Not applicable for egress
            'Destination IP' = ($egressRule.IpRanges | Select-Object -ExpandProperty CidrIp) -join ','
            Region = $egressRule.Region
        }
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$securityGroupDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'SecurityGroups'