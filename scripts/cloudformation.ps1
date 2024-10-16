# Run AWS CLI command to describe CloudFormation stacks and capture the output
$stacksJson = aws cloudformation describe-stacks --output json
$stacks = $stacksJson | ConvertFrom-Json

# Initialize an array to store the details of each CloudFormation stack
$stackDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each CloudFormation stack
foreach ($stack in $stacks.Stacks) {
    # Add details to the array
    $stackDetails += [PSCustomObject]@{
        'Sr. No.'       = $serialNumber++
        'Stack Name'    = $stack.StackName
        'Status'        = $stack.StackStatus
        'Created Time'  = $stack.CreationTime
        'Description'   = $stack.Description
        'Region'        = $stack.StackId.Split(':')[3]
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$stackDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'CloudFormation'