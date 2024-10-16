# Run AWS CLI command to list IAM users and capture the output
$iamUsersJson = aws iam list-users --output json
$iamUsers = $iamUsersJson | ConvertFrom-Json

# Initialize an array to store the details of each IAM user
$iamUserDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each IAM user
foreach ($iamUser in $iamUsers.Users) {
    # Check if MFA is enabled for the user
    $mfa = $null
    ########## $mfaDevicesJson = aws iam list-mfa-devices --user-name $iamUser.UserName --output json 2>$null
    if ($LastExitCode -eq 0) {
        $mfa = "Enabled"
    } else {
        $mfa = "Disabled"
    }

    # Check if the user has console access
    $consoleAccess = "Disabled"
    $accessKeysJson = aws iam list-access-keys --user-name $iamUser.UserName --output json 2>$null
    if ($LastExitCode -eq 0) {
        $consoleAccess = "Enabled"
    }

    # Add details to the array
    $iamUserDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'UserName' = $iamUser.UserName
        'MFA' = $mfa
        'Access Key ID' = ($accessKeysJson | ConvertFrom-Json).AccessKeyMetadata.AccessKeyId
        'ConsoleAccess' = $consoleAccess
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$iamUserDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'IAM'