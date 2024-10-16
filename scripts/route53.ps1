# Run AWS CLI command to list hosted zones and capture the output
$hostedZonesJson = aws route53 list-hosted-zones --output json
$hostedZones = $hostedZonesJson | ConvertFrom-Json

# Initialize an array to store the details of each hosted zone
$hostedZoneDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each hosted zone
foreach ($zone in $hostedZones.HostedZones) {
    # Get hosted zone details
    $name = $zone.Name
    $privateZone = $zone.Config.PrivateZone
    $associatedVpcs = $zone.Config.PrivateZone -as [string[]]
    $resourceRecordSetCount = $zone.ResourceRecordSetCount
    $description = $zone.Config.Comment
    $hostedZoneId = $zone.Id

    # Add details to the array
    $hostedZoneDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Hosted Zone Name' = $name
        'PrivateZone' = $privateZone
        'Associated VPCs' = $associatedVpcs -join ","
        'ResourceRecordSetCount' = $resourceRecordSetCount
        'Description' = $description
        'Hosted zone ID' = $hostedZoneId
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$hostedZoneDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'Route53'