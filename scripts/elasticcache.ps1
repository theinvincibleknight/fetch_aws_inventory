# Run AWS CLI command to describe ElastiCache clusters and capture the output
$cacheClustersJson = aws elasticache describe-cache-clusters --output json
$cacheClusters = $cacheClustersJson | ConvertFrom-Json

# Initialize an array to store the details of each cache cluster
$cacheClusterDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each cache cluster
foreach ($cluster in $cacheClusters.CacheClusters) {
    # Add details to the array
    $cacheClusterDetails += [PSCustomObject]@{
        'Sr. No.'                     = $serialNumber++
        'CacheClusterId'              = $cluster.CacheClusterId
        'ClientDownloadLandingPage'   = $cluster.ClientDownloadLandingPage
        'CacheNodeType'               = $cluster.CacheNodeType
        'Engine'                      = $cluster.Engine
        'EngineVersion'               = $cluster.EngineVersion
        'CacheClusterStatus'          = $cluster.CacheClusterStatus
        'PreferredAvailabilityZone'   = $cluster.PreferredAvailabilityZone
        'CacheClusterCreateTime'      = $cluster.CacheClusterCreateTime
        'CacheSubnetGroupName'        = $cluster.CacheSubnetGroupName
        'SecurityGroupId'             = $cluster.SecurityGroups.SecurityGroupId -join ', '
        'ReplicationGroupId'          = $cluster.ReplicationGroupId
        'AtRestEncryptionEnabled'     = $cluster.AtRestEncryptionEnabled
        'ARN'                         = $cluster.ARN
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$cacheClusterDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'ElastiCache Clusters'
