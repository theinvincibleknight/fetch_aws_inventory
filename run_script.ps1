$outputFile = "C:\Users\Downloads\Files\AWS_Inventory.xlsx"
$profiles = @("inventory-uat", "inventory-dev", "inventory-network", "inventory-prod", "inventory-shared", "inventory-admin")

foreach ($profile in $profiles) {
    # Set the AWS profile
    $env:AWS_PROFILE = $profile

    # Display the current profile
    Write-Output "AWS Profile = $profile"

    # Run the runscript.bat batch script
    & "C:\Users\VisualStudio\Scripts\fetch_aws_inventory\scripts\runscript.bat"

    # Get the current month and year
    $currentDate = Get-Date
    $monthYear = $currentDate.ToString("MMMM-yyyy")  # Format: Month-Year (e.g., "October-2023")

    # Rename the Excel file based on the profile
    switch ($profile) {
        "inventory-uat" { $newFileName = "AWS_Inventory_UAT_$monthYear.xlsx" }
        "inventory-dev" { $newFileName = "AWS_Inventory_Dev_$monthYear.xlsx" }
        "inventory-network" { $newFileName = "AWS_Inventory_Network_$monthYear.xlsx" }
        "inventory-prod" { $newFileName = "AWS_Inventory_Prod_$monthYear.xlsx" }
        "inventory-shared" { $newFileName = "AWS_Inventory_Shared_$monthYear.xlsx" }
        "inventory-admin" { $newFileName = "AWS_Inventory_OldProd_$monthYear.xlsx" }
    }

    # Rename the Excel file
    $newFilePath = Join-Path (Split-Path -Path $outputFile) $newFileName
    Rename-Item -Path $outputFile -NewName $newFilePath
}

Write-Output "All scripts executed successfully, and Excel files renamed."