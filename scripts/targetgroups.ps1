# Run AWS CLI command to describe target groups and capture the output
$targetGroupsJson = aws elbv2 describe-target-groups --output json
$targetGroups = $targetGroupsJson | ConvertFrom-Json

# Initialize an array to store the details of each target group
$targetGroupDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each target group
foreach ($tg in $targetGroups.TargetGroups) {
    # Get target group details
    $name = $tg.TargetGroupName
    $port = $tg.Port
    $arn = $tg.TargetGroupArn
    $protocol = $tg.Protocol
    $targetType = $tg.TargetType
    $loadBalancerArn = $tg.LoadBalancerArns[0]  # Assuming a target group is associated with only one load balancer
    $vpcId = $tg.VpcId
    
    # Describe targets to get registered targets
    $targetsJson = aws elbv2 describe-target-health --target-group-arn $tg.TargetGroupArn --output json
    $targets = $targetsJson | ConvertFrom-Json

    $registeredTargets = $targets.TargetHealthDescriptions.Target.Id
    
    # $registeredTargets = @()

    # foreach ($target in $targets.TargetHealthDescriptions) {
    #     if ($target.TargetHealth.State -eq "healthy") {
    #         if ($targetType -eq "instance") {
    #             $registeredTargets += $target.Target.Id
    #         } elseif ($targetType -eq "ip") {
    #             $registeredTargets += $target.Target.Address
    #         }
    #     }
    # }

    # Get region from load balancer ARN
    # $region = $loadBalancerArn.Split(":")[3]
    $region = $tg.TargetGroupArn.Split(':')[3]

    # Add details to the array
    $targetGroupDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Name' = $name
        'Port' = $port
        'Protocol' = $protocol
        'Target type' = $targetType
        'ARN' = $arn
        'Load balancer' = $loadBalancerArn
        'VPC ID' = $vpcId
        'Registered Targets' = $registeredTargets -join ","
        'Region' = $region
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$targetGroupDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'TG_GRP'