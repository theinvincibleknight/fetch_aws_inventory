# Run AWS CLI command to describe internet gateways and capture the output
$igwsJson = aws ec2 describe-internet-gateways --output json
$igws = $igwsJson | ConvertFrom-Json

# Initialize an array to store the details of each internet gateway
$igwDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each internet gateway
foreach ($igw in $igws.InternetGateways) {
    # Get internet gateway details
    #$igwName = $igw.Tags | Where-Object { $_.Key -eq "Name" } | Select-Object -ExpandProperty Value
    #$igwId = $igw.InternetGatewayId
    #$vpcId = ($igw.Attachments).VpcId
    #$region = $igws.ResponseMetadata.RequestId.Split('.')[1]

    # Add details to the array
    $igwDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Name' = $igw.Tags | Where-Object { $_.Key -eq "Name" } | Select-Object -ExpandProperty Value
        'Internet Gateway ID' = $igw.InternetGatewayId
        'VPC ID' = $igw.Attachments.VpcId
        #'Region' = $region
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$igwDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'IGW'