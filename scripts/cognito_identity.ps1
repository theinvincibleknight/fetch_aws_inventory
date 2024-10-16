# Run AWS CLI command to list Cognito Identity Pools and capture the output
$identityPoolsJson = aws cognito-identity list-identity-pools --max-results 60 --output json
$identityPools = $identityPoolsJson | ConvertFrom-Json

# Initialize an array to store the details of each Cognito Identity Pool
$identityPoolDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each Cognito Identity Pool
foreach ($pool in $identityPools.IdentityPools) {
    # Get detailed information for each Identity Pool
    $poolDetailJson = aws cognito-identity describe-identity-pool --identity-pool-id $pool.IdentityPoolId --output json
    $poolDetail = $poolDetailJson | ConvertFrom-Json
    
    # Add details to the array
    $identityPoolDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Identity Pool Name' = $poolDetail.IdentityPoolName
        'Identity Pool ID' = $poolDetail.IdentityPoolId
        'Allow Unauthenticated Identities' = $poolDetail.AllowUnauthenticatedIdentities
        #'Supported Login Providers' = $poolDetail.SupportedLoginProviders -join ", "
        #'Developer Provider Name' = $poolDetail.DeveloperProviderName
        #'OpenID Connect Provider ARNs' = $poolDetail.OpenIdConnectProviderARNs -join ", "
        'Cognito Identity Providers' = ($poolDetail.CognitoIdentityProviders | ForEach-Object { $_.ProviderName }) -join ", "
        #'SAML Provider ARNs' = $poolDetail.SamlProviderARNs -join ", "
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$identityPoolDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'Cognito-Identity'