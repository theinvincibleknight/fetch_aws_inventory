# Fetch all ECS cluster ARNs
$clustersJson = aws ecs list-clusters --output json
$clusters = ($clustersJson | ConvertFrom-Json).clusterArns

# Initialize an array to store the details of each ECS service
$serviceDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Loop through each cluster ARN
foreach ($clusterArn in $clusters) {
    # Fetch all service ARNs within the current ECS cluster
    $servicesJson = aws ecs list-services --cluster $clusterArn --output json
    $services = ($servicesJson | ConvertFrom-Json).serviceArns

    # Loop through each service ARN and fetch details
    foreach ($serviceArn in $services) {
        # Get details of each ECS service
        $serviceJson = aws ecs describe-services --cluster $clusterArn --services $serviceArn --output json
        $service = ($serviceJson | ConvertFrom-Json).services[0]

        # Add details to the array
        $serviceDetails += [PSCustomObject]@{
            'Sr. No.'          = $serialNumber++
            'Cluster ARN'      = $clusterArn
            'Service Name'     = $service.serviceName
            'Status'           = $service.status
            'Desired Count'    = $service.desiredCount
            'Running Count'    = $service.runningCount
            'Pending Count'    = $service.pendingCount
            'Launch Type'      = $service.launchType
            'Created At'       = $service.createdAt
            'Task Definition'  = $service.taskDefinition
        }
    }
}

# Export the details to a CSV file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$serviceDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'ECS_Services'