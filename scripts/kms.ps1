# Run AWS CLI command to list keys and capture the output
$kmsKeysJson = aws kms list-keys --output json
$kmsKeys = $kmsKeysJson | ConvertFrom-Json

# Initialize an array to store the details of each KMS key
$kmsDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each KMS key
foreach ($key in $kmsKeys.Keys) {
    # Get key details
    $keyId = $key.KeyId
    
    # Get alias for the key
    $aliasesJson = aws kms list-aliases --key-id $keyId --output json
    $aliases = $aliasesJson | ConvertFrom-Json
    
    $aliasesList = @()
    foreach ($alias in $aliases.Aliases) {
        $aliasesList += $alias.AliasName
    }
    
    # Get key description
    $keyDescriptionJson = aws kms describe-key --key-id $keyId --output json
    $keyDescription = $keyDescriptionJson | ConvertFrom-Json
    #$description = $keyDescription.KeyMetadata.Description
    
    # Get key manager
    #$keyManager = $keyDescription.KeyMetadata.KeyManager
    
    # Get key spec
    #$keySpec = $keyDescription.KeyMetadata.KeySpec
    
    # Get region
    #$region = $keyId.Split(":")[3]

    # Add details to the array
    $kmsDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Aliases' = $aliasesList -join ","
        'Key ID' = $keyId
        'Description' = $keyDescription.KeyMetadata.Description
        'KeyManager' = $keyDescription.KeyMetadata.KeyManager
        'KeySpec' = $keyDescription.KeyMetadata.KeySpec
        'Region' = $key.KeyArn.Split(':')[3]
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$kmsDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'KMS'