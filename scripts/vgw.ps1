# Run AWS CLI command to describe VPN gateways and capture the output
$vgwsJson = aws ec2 describe-vpn-gateways --output json
$vgws = $vgwsJson | ConvertFrom-Json

# Initialize an array to store the details of each VPN gateway
$vgwDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each VPN gateway
foreach ($vgw in $vgws.VpnGateways) {
    # Get VPN gateway details
    $vgwId = $vgw.VpnGatewayId
    $vgwName = $vgw.Tags | Where-Object { $_.Key -eq "Name" } | Select-Object -ExpandProperty Value
    $state = $vgw.State
    $type = $vgw.Type
    $AmazonSideAsn = $vgw.AmazonSideAsn
    # $attachments = $vgw.Attachments | ForEach-Object { $_.VpcId }
    $attachments = $vgw.VpcAttachments.VpcId
    # $region = $vgw.Tags | Where-Object { $_.Key -eq "aws:cloudformation:stack-name" } | Select-Object -ExpandProperty Value

    # Add details to the array
    $vgwDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'VGW ID' = $vgwId
        'Name' = $vgwName
        'State' = $state
        'Type' = $type
        'AmazonSideASN' = $AmazonSideAsn
        'Attachments' = $attachments -join ","
        #'Region' = $region
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$vgwDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'VGW'