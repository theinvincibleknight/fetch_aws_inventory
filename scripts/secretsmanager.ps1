# Run AWS CLI command to list secrets and capture the output
$secrets = aws secretsmanager list-secrets --output json | ConvertFrom-Json

# Initialize an array to store the details of each secret
$secretDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each secret
foreach ($secret in $secrets.SecretList) {
    # Get additional details for each secret
    $secretDetails += [PSCustomObject]@{
        'Sr. No' = $serialNumber++
        ARN = $secret.ARN
        Name = $secret.Name
        Description = $secret.Description
        LastChangedDate = $secret.LastChangedDate
        LastAccessedDate = $secret.LastAccessedDate
        CreatedDate = $secret.CreatedDate
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$secretDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'SecretManagers'