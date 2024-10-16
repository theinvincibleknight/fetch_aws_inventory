# Run AWS CLI command to list Glue jobs and capture the output
$jobsJson = aws glue get-jobs --output json
$jobss = $jobsJson | ConvertFrom-Json

# Initialize an array to store the details of each Glue job
$jobDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each Glue job
foreach ($job in $jobss.jobs) {
    # Get details of each Glue job
    #$jobJson = aws glue get-job --job-name $jobName --output json
    #$job = $jobJson | ConvertFrom-Json

    # Add details to the array
    $jobDetails += [PSCustomObject]@{
        'Sr. No.'        = $serialNumber++
        'Job Name'       = $job.Name
        'Description'    = $job.Description
        'Role'           = $job.Role
        'CreatedOn'      = $job.CreatedOn
        'LastModifiedOn' = $job.LastModifiedOn
        'ScriptLocation' = $job.Command.ScriptLocation
    }
}

# Export the details to an Excel file (Requires ImportExcel module)
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$jobDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'Glue'
