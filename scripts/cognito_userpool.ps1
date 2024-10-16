# Run AWS CLI command to list user pools and capture the output
$cognitoJson = aws cognito-idp list-user-pools --max-results 20 --output json
$cognitoPools = $cognitoJson | ConvertFrom-Json

# Initialize an array to store the details of each user pool
$userPoolDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each user pool
foreach ($pool in $cognitoPools.UserPools) {
    # Get user pool details
    $poolDetailsJson = aws cognito-idp describe-user-pool --user-pool-id $pool.Id --output json
    $poolDetails = $poolDetailsJson | ConvertFrom-Json

    # Get number of users  
    $usersCount = $poolDetails.UserPool.EstimatedNumberOfUsers

    # Add details to the array
    $userPoolDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'User pool name' = $pool.Name
        'User Pool ID' = $pool.Id
        'Number of Users' = $usersCount
        'Region' = $poolDetails.UserPool.Arn.Split(':')[3]
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$userPoolDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'Cognito-UserPools'