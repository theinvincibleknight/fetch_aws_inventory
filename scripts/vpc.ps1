# Run AWS CLI command to describe VPCs and capture the output
$vpcsJson = aws ec2 describe-vpcs --output json
$vpcs = $vpcsJson | ConvertFrom-Json

# Initialize an array to store the details of each VPC
$vpcDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each VPC
foreach ($vpc in $vpcs.Vpcs) {
    # Get VPC details
    $vpcName = $vpc.Tags | Where-Object { $_.Key -eq "Name" } | Select-Object -ExpandProperty Value
    $vpcId = $vpc.VpcId
    $ipv4Cidr = $vpc.CidrBlock
    $defaultVpc = $vpc.IsDefault
    #$mainRouteTable = $vpc.Tags | Where-Object { $_.Key -eq "aws:ec2:vpc" } | Select-Object -ExpandProperty Value
    #$region = $vpcs.ResponseMetadata.RequestId.Split('.')[1]

    # Add details to the array
    $vpcDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Name' = $vpcName
        'VPC ID' = $vpcId
        'IPv4 CIDR' = $ipv4Cidr
        'Default VPC' = $defaultVpc
        #'Main Route Table' = $mainRouteTable
        #'Region' = $region
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$vpcDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'VPC'