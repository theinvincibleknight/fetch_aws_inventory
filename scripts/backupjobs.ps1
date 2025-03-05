# Run AWS CLI command to list backup jobs and capture the output
$backupJobsJson = aws backup list-backup-jobs --output json
$backupJobs = $backupJobsJson | ConvertFrom-Json

# Initialize an array to store the details of each backup job
$backupJobDetails = @()

# Initialize a counter for serial numbers
$jobSerialNumber = 1

# Iterate over each backup job
foreach ($job in $backupJobs.BackupJobs) {
    # Add details to the array
    $backupJobDetails += [PSCustomObject]@{
        'Job Sr. No.'         = $jobSerialNumber++
        'BackupVaultName'     = $job.BackupVaultName
        'RecoveryPointArn'    = $job.RecoveryPointArn
        'ResourceArn'         = $job.ResourceArn
        'BackupSizeInBytes'   = $job.BackupSizeInBytes
        'ResourceType'        = $job.ResourceType
        'ResourceName'        = $job.ResourceName
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$backupJobDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'Backup Jobs'
