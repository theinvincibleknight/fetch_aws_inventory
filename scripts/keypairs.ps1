# Run AWS CLI command to describe key pairs and capture the output
$keyPairsJson = aws ec2 describe-key-pairs --output json
$keyPairs = $keyPairsJson | ConvertFrom-Json

# Initialize an array to store the details of each Key Pair
$keyPairDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each Key Pair
foreach ($keyPair in $keyPairs.KeyPairs) {
    # Get Key Pair details
    #$name = $keyPair.KeyName
    #$type = $keyPair.KeyType
    #$id = $keyPair.KeyPairId
    # $associatedInstance = $keyPair.KeyName # Key pairs are not directly associated with instances; use the key name for identification

    # Add details to the array
    $keyPairDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Name' = $keyPair.KeyName
        'Type' = $keyPair.KeyType
        'ID' = $keyPair.KeyPairId
        # 'Associated Instance' = $associatedInstance
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$keyPairDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'KeyPairs'