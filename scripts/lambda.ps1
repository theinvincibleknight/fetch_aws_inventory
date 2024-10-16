# Run AWS CLI command to list Lambda functions and capture the output
$lambdaFunctionsJson = aws lambda list-functions --output json
$lambdaFunctions = $lambdaFunctionsJson | ConvertFrom-Json

# Initialize an array to store the details of each Lambda function
$lambdaDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each Lambda function
foreach ($lambdaFunction in $lambdaFunctions.Functions) {
    # Get additional details for each Lambda function and increment serial number
    $lambdaDetails += [PSCustomObject]@{
        'Sr. No' = $serialNumber++
        'Function Name' = $lambdaFunction.FunctionName
        Runtime = $lambdaFunction.Runtime
        Role = $lambdaFunction.Role
        VpcId = $null
        SubnetId = $null
        SecurityGroupId = $null
    }

    # Fetch VPC configurations if available
    if ($lambdaFunction.VpcConfig) {
        $lambdaDetails[-1].VpcId = $lambdaFunction.VpcConfig.VpcId
        $lambdaDetails[-1].SubnetId = $lambdaFunction.VpcConfig.SubnetIds -join ','
        $lambdaDetails[-1].SecurityGroupId = $lambdaFunction.VpcConfig.SecurityGroupIds -join ','
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$lambdaDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'Lambda'

# Write-Host "Lambda details saved in Excel file: $exportPath"