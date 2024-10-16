# Run AWS CLI command to list OpenSearch domains and capture the output
$domainsJson = aws es list-domain-names --output json
$domains = $domainsJson | ConvertFrom-Json

# Initialize an array to store the details of each OpenSearch domain
$domainDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each OpenSearch domain
foreach ($domain in $domains.DomainNames) {
    # Get OpenSearch domain details
    $domainName = $domain.DomainName
    
    # Describe the domain to get more details
    $domainInfoJson = aws es describe-elasticsearch-domain --domain-name $domainName --output json
    $domainInfo = $domainInfoJson | ConvertFrom-Json
    
    #$engine = $domainInfo.DomainStatus.EngineVersion
    $version = $domainInfo.DomainStatus.ElasticsearchVersion
    $endpoint = $domainInfo.DomainStatus.Endpoint
    $instancetype = $domainInfo.DomainStatus.ElasticsearchClusterConfig.InstanceType
    $volumetype = $domainInfo.DomainStatus.EBSOptions.VolumeType
    $volumesize = $domainInfo.DomainStatus.EBSOptions.VolumeSize
    # $updateStatus = $domainInfo.DomainStatus.UpgradeProcessing
    $ultraWarmStorage = $domainInfo.DomainStatus.ElasticsearchClusterConfig.WarmType
    # $coldStorage = $domainInfo.DomainStatus.AdvancedOptions.ColdStorageOptions.Enabled
    
    # Add details to the array
    $domainDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Domain Name' = $domainName
        'EngineVersion' = $version
        'Endpoint' = $endpoint
        'InstanceType' = $instancetype
        'VolumeType' = $volumetype
        'VolumeSize' = $volumesize
        'UltraWarm Storage Type' = $ultraWarmStorage
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$domainDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'OpenSearch'