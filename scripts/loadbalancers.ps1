# Run AWS CLI command to describe load balancers and capture the output
$loadBalancersJson = aws elbv2 describe-load-balancers --output json
$loadBalancers = $loadBalancersJson | ConvertFrom-Json

# Initialize an array to store the details of each load balancer
$loadBalancerDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each load balancer
foreach ($lb in $loadBalancers.LoadBalancers) {
    # Get load balancer details
    # $name = $lb.LoadBalancerName
    # $dnsName = $lb.DNSName
    # $state = $lb.State.Code
    # $vpcId = $lb.VpcId
    # $subnetId = $lb.AvailabilityZones.SubnetId -Join ","
    # $availabilityZones = $lb.AvailabilityZones.ZoneName -join ","
    # $securityGroup = $lb.SecurityGroups
    # $type = $lb.Type
    #$protocolPort = $lb.Listeners.ProtocolPort -join ","
    #$defaultRoutingRule = $lb.DefaultActions.Type -join ","
    
    # Add details to the array
    $loadBalancerDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Name' = $lb.LoadBalancerName
        'DNS Name' = $lb.DNSName
        'State' = $lb.State.Code
        'VPC ID' = $lb.VpcId
        'Subnet ID' = $lb.AvailabilityZones.SubnetId -Join ","
        'Availability Zones' = $lb.AvailabilityZones.ZoneName -join ","
        'Security Group' = $lb.SecurityGroups -Join ","
        'Type' = $lb.Type
        #'Protocol:Port' = $protocolPort
        #'Default Routing Rule' = $defaultRoutingRule
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$loadBalancerDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'LoadBalancers'