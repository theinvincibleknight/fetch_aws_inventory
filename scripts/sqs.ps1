# List all SQS queues
$queuesJson = aws sqs list-queues --output json
$queues = $queuesJson | ConvertFrom-Json

# Initialize an array to store the details of each queue
$queueDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each queue
foreach ($queueUrl in $queues.QueueUrls) {
    # Get queue details
    $queueAttributesJson = aws sqs get-queue-attributes --queue-url $queueUrl --attribute-names All --output json
    $queueAttributes = $queueAttributesJson | ConvertFrom-Json

    # Get queue name
    $queueName = ($queueUrl -split "/")[-1]

    # Get queue type
    # $queueType = $queueAttributes.Attributes.QueueArn -split ":" | Select-Object -Last 1

    # Get queue encryption status
    $encryption = $null -ne $queueAttributes.Attributes.KmsMasterKeyId

    # Initialize Lambda triggers variable
    # $lambdaTriggers = ""

    # Get region from queue ARN
    $region = $queueAttributes.Attributes.QueueArn.Split(':')[3]


    # Add details to the array
    $queueDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Name' = $queueName
        #'Type' = $queueType
        'Encryption' = $encryption
        #'Lambda Triggers' = $lambdaTriggers
        'Region' = $region
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$queueDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'SQS'