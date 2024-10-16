# Fetch AWS Inventory

## Overview

AWS does not provide a native feature to fetch all AWS resources and import them as an AWS Inventory. This PowerShell script helps in retrieving the resources and saving them in an Excel file, which can be used as an inventory.

## Prerequisites

Before running the script, you need to fetch the list of configured AWS profiles. You can do this by executing the following command in PowerShell:

```powershell
aws configure list-profiles
```

This command will return a list of your configured profiles, for example:

```
inventory-uat
inventory-dev
inventory-network
inventory-prod
inventory-shared
inventory-admin
script-admin
```

## Configuration

1. **Update the Script**: Open the `run_script.ps1` file and update the `$profiles` array with the required profile names:

    ```powershell
    $profiles = @("inventory-uat", "inventory-dev", "inventory-network", "inventory-prod", "inventory-shared", "inventory-admin")
    ```

2. **Set Output File Path**: Update the `$outputFile` path in the script to specify where you want to save the output.

3. **Update Batch File Path**: Ensure that the path to the `runscript.bat` file is correctly set in the script.

## Running the Script

Once you have configured the script, you can open PowerShell and run it using the following command:

```powershell
.\run_script.ps1
```

The script will invoke the `runscript.bat` file, which will execute all the PowerShell scripts stored in the `scripts` folder. The output will be saved to the specified output file path.

### Example Output

When you run the script, you should see output similar to the following:

```
AWS Profile = inventory-uat
Running amplify.ps1
Running apigw.ps1
Running certificate.ps1
.
.
.
.
Running waf.ps1
All scripts executed successfully.
AWS Profile = inventory-dev
Running amplify.ps1
Running apigw.ps1
.
.
.
```

## Acknowledgments

- AWS for providing the cloud infrastructure.
- The community for their contributions and support.

```
Feel free to modify any sections as needed to better fit your project!
```
