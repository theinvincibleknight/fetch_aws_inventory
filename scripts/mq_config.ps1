# Run AWS CLI command to list Amazon MQ configurations and capture the output
$mqConfigsJson = aws mq list-configurations --output json
$mqConfigs = $mqConfigsJson | ConvertFrom-Json

# Initialize an array to store the details of each Amazon MQ configuration
$mqConfigDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each Amazon MQ configuration
foreach ($config in $mqConfigs.Configurations) {
    # Get configuration details
    $configDetailsJson = aws mq describe-configuration --configuration-id $config.Id --output json
    $configDetails = $configDetailsJson | ConvertFrom-Json

    # Get availability zone
    # $availabilityZone = $configDetails.LatestRevision.DeploymentMode

    # Add details to the array
    $mqConfigDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Configuration Name' = $config.Name
        'EngineType' = $configDetails.EngineType
        'EngineVersion' = $configDetails.EngineVersion
        'Availability Zone' = $configDetails.Arn.Split(':')[3]
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$mqConfigDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'MQ_Config'