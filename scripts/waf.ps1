# Run AWS CLI command to list AWS WAF Web ACLs and capture the output
$webAclsJson = aws wafv2 list-web-acls --scope REGIONAL --query 'WebACLs[].{Name:Name, ID:Id, Description:Description, Rules:RulesCount, DefaultAction:DefaultAction.Action}' --output json
$webAcls = $webAclsJson | ConvertFrom-Json

# Initialize an array to store the details of each AWS WAF Web ACL
$webAclDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each AWS WAF Web ACL
foreach ($webAcl in $webAcls) {
    # Get AWS WAF Web ACL details
    $name = $webAcl.Name
    $id = $webAcl.ID
    $description = $webAcl.Description
    #$rules = $webAcl.Rules
    #$defaultAction = $webAcl.DefaultAction

    # Add details to the array
    $webAclDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Name' = $name
        'ID' = $id
        'Description' = $description
        #'Rules' = $rules
        #'Default Action' = $defaultAction
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$webAclDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'WAF'