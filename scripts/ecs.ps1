# Fetch all ECS cluster ARNs
$clustersJson = aws ecs list-clusters --output json
$clusters = ($clustersJson | ConvertFrom-Json).clusterArns

# Initialize an array to store the details of each ECS cluster
$clusterDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Loop through each cluster ARN and fetch details
foreach ($clusterArn in $clusters) {
    # Get details of each ECS cluster
    $clusterJson = aws ecs describe-clusters --clusters $clusterArn --output json
    $cluster = ($clusterJson | ConvertFrom-Json).clusters[0]

    # Add details to the array
    $clusterDetails += [PSCustomObject]@{
        'Sr. No.'                   = $serialNumber++
        'Cluster Name'              = $cluster.clusterName
        'Status'                    = $cluster.status
        'ARN'                       = $cluster.clusterArn
        'Running Tasks'             = $cluster.runningTasksCount
        'Pending Tasks'             = $cluster.pendingTasksCount
        'Active Services'           = $cluster.activeServicesCount
        'Registered Instances'      = $cluster.registeredContainerInstancesCount
        #'Created At'                = $cluster.createdAt
    }
}

# Export the details to a CSV file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$clusterDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'ECS'