# Run AWS CLI command to describe Transit Gateway attachments and capture the output
$attachmentsJson = aws ec2 describe-transit-gateway-attachments --output json
$attachments = $attachmentsJson | ConvertFrom-Json

# Initialize an array to store the details of each Transit Gateway attachment
$attachmentDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each Transit Gateway attachment
foreach ($attachment in $attachments.TransitGatewayAttachments) {
    # Get Transit Gateway attachment details
    $attachmentId = $attachment.TransitGatewayAttachmentId
    $attachmentName = $attachment.Tags | Where-Object { $_.Key -eq "Name" } | Select-Object -ExpandProperty Value
    $transitGatewayId = $attachment.TransitGatewayId
    $resourceType = $attachment.ResourceType
    $resourceId = $attachment.ResourceId
    $state = $attachment.State
    # $region = $attachment.Tags | Where-Object { $_.Key -eq "aws:cloudformation:stack-name" } | Select-Object -ExpandProperty Value

    # Add details to the array
    $attachmentDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Attachment ID' = $attachmentId
        'Name' = $attachmentName
        'Transit Gateway ID' = $transitGatewayId
        'Resource Type' = $resourceType
        'Resource ID' = $resourceId
        'State' = $state
        #'Region' = $region
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$attachmentDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'TGWAttachments'