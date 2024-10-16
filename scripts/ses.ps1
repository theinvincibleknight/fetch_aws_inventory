# Run AWS CLI command to list SES identities and capture the output
$identitiesJson = aws ses list-identities --output json
$identities = $identitiesJson | ConvertFrom-Json

# Initialize an array to store the details of each SES identity
$identityDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each SES identity
foreach ($identity in $identities.Identities) {
    # Get identity type
    $identityType = if ($identity -like "*@*") { "Email Address" } else { "Domain" }

    # Add details to the array
    $identityDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Identity' = $identity
        'Identity Type' = $identityType
        'Status' = "Status" # Use AWS CLI or API to fetch status
        'Region' = "Region" # Use AWS CLI or API to fetch region
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$identityDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'SES'