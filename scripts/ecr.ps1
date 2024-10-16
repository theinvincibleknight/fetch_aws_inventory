# Run AWS CLI command to list all ECR repositories and capture the output
$repositoriesJson = aws ecr describe-repositories --output json
$repositories = $repositoriesJson | ConvertFrom-Json

# Initialize an array to store the details of each repository
$repositoryDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each repository
foreach ($repo in $repositories.repositories) {
    # Fetch additional details like scan configuration and tag immutability
    # $scanConfigJson = aws ecr get-repository-scanning-configuration --repository-name $repo.repositoryName --output json
    # $scanConfig = $scanConfigJson | ConvertFrom-Json

    # Add repository details to the array
    $repositoryDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Repository Name' = $repo.repositoryName
        'URI' = $repo.repositoryUri
        'Created At' = $repo.createdAt
        'Tag Immutability' = $repo.imageTagMutability
        'Scan Frequency' = $repo.imageScanningConfiguration.scanOnPush
        'Encryption Type' = $repo.encryptionConfiguration.encryptionType
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$repositoryDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'ECR'