# Run AWS CLI command to list MSK clusters and capture the output
$mskClustersJson = aws kafka list-clusters --output json
$mskClusters = $mskClustersJson | ConvertFrom-Json

# Initialize an array to store the details of each MSK cluster
$mskDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each MSK cluster
foreach ($cluster in $mskClusters.ClusterInfoList) {
    # Get cluster details
    $clusterArn = $cluster.ClusterArn
    $clusterName = $cluster.ClusterName

    # Describe cluster to get additional details
    $clusterDetailsJson = aws kafka describe-cluster --cluster-arn $clusterArn --output json
    $clusterDetails = $clusterDetailsJson | ConvertFrom-Json

    # Get cluster type
    # $clusterType = $clusterDetails.ClusterInfo.ClusterType

    # Get Apache Kafka version
    $kafkaVersion = $clusterDetails.ClusterInfo.CurrentBrokerSoftwareInfo.KafkaVersion

    # Get broker instance type
    $brokerInstanceType = $clusterDetails.ClusterInfo.BrokerNodeGroupInfo.InstanceType

    # Get EBS storage per broker
    $ebsStoragePerBroker = $clusterDetails.ClusterInfo.BrokerNodeGroupInfo.StorageInfo.EbsStorageInfo.VolumeSize

    # Get brokers per zone
    $brokersPerZone = $clusterDetails.ClusterInfo.NumberOfBrokerNodes

    # Get zone
    # $zone = $clusterDetails.ClusterInfo.BrokerNodeGroupInfo.ClientSubnets[0].AvailabilityZone

    # Get VPC
    # $vpc = $clusterDetails.ClusterInfo.EncryptionInfo.EncryptionAtRest.DataVolumeKMSKeyId

    # Get subnet
    # $subnet = $clusterDetails.ClusterInfo.BrokerNodeGroupInfo.ClientSubnets[0].SubnetArn
    $subnet = $cluster.BrokerNodeGroupInfo.ClientSubnets -join ","

    # Get broker details
    $brokerDetails = $clusterDetails.ClusterInfo.BrokerNodeGroupInfo.BrokerAZDistribution

    # Get security groups
    # $securityGroups = $clusterDetails.ClusterInfo.EncryptionInfo.EncryptionInTransit.ClientBroker
    $securityGroups = $cluster.BrokerNodeGroupInfo.SecurityGroups -join ","

    # Get availability zone
    # $availabilityZone = $clusterDetails.ClusterInfo.BrokerNodeGroupInfo.ClientSubnets[0].AvailabilityZone
    $availabilityZone = $cluster.ClusterArn.Split(':')[3]

    # Add details to the array
    $mskDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Cluster Name' = $clusterName
        #'Cluster type' = $clusterType
        'Apache Kafka version' = $kafkaVersion
        'Broker Instance type' = $brokerInstanceType
        'EBS Storage per broker' = $ebsStoragePerBroker
        'Brokers per zone' = $brokersPerZone
        #'Zone' = $zone
        #'VPC' = $vpc
        'Subnet' = $subnet
        'Broker details' = $brokerDetails
        'Security Groups' = $securityGroups
        'Availability Zone' = $availabilityZone
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$mskDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'MSK'