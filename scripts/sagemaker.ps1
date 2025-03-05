# Run AWS CLI command to list SageMaker notebook instances and capture the output
$notebookInstancesJson = aws sagemaker list-notebook-instances --output json
$notebookInstances = $notebookInstancesJson | ConvertFrom-Json

# Initialize an array to store the details of each notebook instance
$notebookDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each notebook instance
foreach ($instance in $notebookInstances.NotebookInstances) {
    # Add details to the array
    $notebookDetails += [PSCustomObject]@{
        'Sr. No.'                = $serialNumber++
        'NotebookInstanceName'   = $instance.NotebookInstanceName
        'NotebookInstanceArn'    = $instance.NotebookInstanceArn
        'NotebookInstanceStatus' = $instance.NotebookInstanceStatus
        'Url'                    = $instance.Url
        'InstanceType'           = $instance.InstanceType
        'CreationTime'           = $instance.CreationTime
        'LastModifiedTime'       = $instance.LastModifiedTime
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$notebookDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'SageMaker'
