# Run AWS CLI command to list backup plans and capture the output
$backupPlansJson = aws backup list-backup-plans --output json
$backupPlans = $backupPlansJson | ConvertFrom-Json

# Initialize an array to store the details of each backup plan
$backupPlanDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each backup plan
foreach ($plan in $backupPlans.BackupPlansList) {
    # Add details to the array
    $backupPlanDetails += [PSCustomObject]@{
        'Sr. No.'             = $serialNumber++
        'BackupPlanId'        = $plan.BackupPlanId
        'BackupPlanName'      = $plan.BackupPlanName
        'CreationDate'        = $plan.CreationDate
        'LastExecutionDate'   = $plan.LastExecutionDate
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$backupPlanDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'Backup Plans'
