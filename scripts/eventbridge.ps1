# Run AWS CLI command to list EventBridge rules and capture the output
$rulesJson = aws events list-rules --output json
$rules = $rulesJson | ConvertFrom-Json

# Initialize an array to store the details of each EventBridge rule
$ruleDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Loop through each rule
foreach ($rule in $rules.Rules) {
    # Get the rule details
    # $ruleDetail = aws events describe-rule --name $rule.Name --output json | ConvertFrom-Json

    # Add details to the array
    $ruleDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Name'               = $rule.Name
        'Arn'                = $rule.Arn
        'State'              = $rule.State
        # 'Type'               = $ruleDetail.EventPattern | ? { $_.sourceIdentifier -eq "aws.events" } | Select-Object -ExpandProperty 'detail-type'
        'EventPattern'       = $rule.EventPattern
        'Description'        = $rule.Description
        'ScheduleExpression' = $rule.ScheduleExpression
        'Region'             = $rule.Arn.Split(':')[3]
    }
}

# Export the details to a CSV file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$ruleDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'EventBridge'