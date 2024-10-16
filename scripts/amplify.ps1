# Run AWS CLI command to list Amplify projects and capture the output
$projectsJson = aws amplify list-apps --output json
$projects = $projectsJson | ConvertFrom-Json

# Initialize an array to store the details of each Amplify project
$projectDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each Amplify project
foreach ($project in $projects.apps) {
    # Add details to the array
    $projectDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Name' = $project.name
        'Repository' = $project.repository
        'Platform' = $project.platform
        'Default Domain' = $project.defaultDomain
        'Created Time' = $project.createTime
        'Region' = $project.appArn.Split(':')[3]
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$projectDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'Amplify'