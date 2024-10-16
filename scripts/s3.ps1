# Run AWS CLI command to list S3 buckets and capture the output
$s3Buckets = aws s3api list-buckets --query "Buckets[*].{Name: Name, CreationDate: CreationDate}" --output json | ConvertFrom-Json

# Initialize an array to store the details of each S3 bucket
$s3Details = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each S3 bucket
foreach ($bucket in $s3Buckets) {
    # Get bucket region
    $region = aws s3api get-bucket-location --bucket $bucket.Name --output text

    # Get bucket access
    $access = aws s3api get-bucket-acl --bucket $bucket.Name --query "Grants[?Grantee.URI == 'http://acs.amazonaws.com/groups/global/AllUsers'].Permission" --output text
    if ($access -eq "READ") {
        $access = "Public"
    } else {
        $access = "Private"
    }

    # Add details to the array
    $s3Details += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Bucket Name' = $bucket.Name
        'Region' = $region
        'Access' = $access
        'Creation Date' = $bucket.CreationDate
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$s3Details | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'S3'