# Run AWS CLI command to list CloudFront distributions and capture the output
$cloudfrontJson = aws cloudfront list-distributions --output json
$cloudfrontDistributions = $cloudfrontJson | ConvertFrom-Json

# Initialize an array to store the details of each CloudFront distribution
$cloudfrontDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each CloudFront distribution
foreach ($distribution in $cloudfrontDistributions.DistributionList.Items) {
    
    # $type = $distribution.Origins.Items[0].OriginPath

    # Add details to the array
    $cloudfrontDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'ID' = $distribution.Id
        # 'Type' = $type
        'Domain Name' = $distribution.DomainName
        'Alternative Domain Names' = $distribution.Aliases.Items -join ','
        'Origins' = $distribution.Origins.Items[0].DomainName
        'Status' = $distribution.Status
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$cloudfrontDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'CloudFront'