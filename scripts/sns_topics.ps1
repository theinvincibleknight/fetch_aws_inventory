# Run AWS CLI command to list topics and capture the output
$topicsJson = aws sns list-topics --output json
$topics = $topicsJson | ConvertFrom-Json

# Initialize an array to store the details of each SNS topic
$topicDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each topic
foreach ($topic in $topics.Topics) {
    # Get topic details
    $topicName = $topic.TopicArn.Split(":")[-1]
    $topicType = "Standard"  # Assuming all topics are standard
    $topicArn = $topic.TopicArn
    $region = $topicArn.Split(":")[3]

    # Add details to the array
    $topicDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Topic Name' = $topicName
        'Type' = $topicType
        'ARN' = $topicArn
        'Region' = $region
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$topicDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'SNS-Topics'