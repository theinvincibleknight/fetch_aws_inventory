# Run AWS CLI command to describe CloudWatch LogGroups and capture the output
$logGroupsJson = aws logs describe-log-groups --output json
$logGroups = $logGroupsJson | ConvertFrom-Json

# Initialize an array to store the details of each CloudWatch LogGroup
$logGroupDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each CloudWatch LogGroup
foreach ($logGroup in $logGroups.logGroups) {
    #echo "Loggroup $logGroup.retentionInDays"
    # Write data to Excel
    $logGroupDetails += [PSCustomObject]@{
        'Sr. No' = $serialNumber++
        Name = $logGroup.logGroupName
        CreationTime = $logGroup.creationTime
        Retention = $logGroup.retentionInDays
        MetricFilters = $logGroup.metricFilterCount
        StoredBytes = $logGroup.storedBytes
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$logGroupDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'LogGroups'

# Write-Host "CloudWatch LogGroup details saved in Excel file: $exportPath"