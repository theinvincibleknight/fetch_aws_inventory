# Initialize an array to store the details of each parameter
$parameterDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Run AWS CLI command to describe parameters and capture the output in text format
$parametersText = aws ssm describe-parameters --query "Parameters[*].[Name, Type]" --output text

# Split the output into lines
$parametersArray = $parametersText -split "`n"

# Iterate over each parameter line
foreach ($parameter in $parametersArray) {
    # Split the name and type
    $parameterInfo = $parameter -split "\s+"
    
    # Add details to the array
    $parameterDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Name'    = $parameterInfo[0]  # Name
        'Type'    = $parameterInfo[1]  # Type
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$parameterDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'SSM Parameters'
