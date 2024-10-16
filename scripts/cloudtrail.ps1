# Run AWS CLI command to describe CloudTrail trails and capture the output
$trailsJson = aws cloudtrail describe-trails --output json
$trails = $trailsJson | ConvertFrom-Json

# Initialize an array to store the details of each CloudTrail trail
$trailDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each CloudTrail trail
foreach ($trail in $trails.trailList) {
    # Get additional details for each CloudTrail trail and increment serial number
    $trailDetails += [PSCustomObject]@{
        'Sr. No' = $serialNumber++
        Name = $trail.Name
        S3BucketName = $trail.S3BucketName
        MultiRegion = $trail.IsMultiRegionTrail
        CloudWatchLogGroup = $trail.CloudWatchLogsLogGroupArn
        Region = $trail.HomeRegion
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$trailDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'CloudTrail'

# Write-Host "CloudTrail details saved in Excel file: $exportPath"