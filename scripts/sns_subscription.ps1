# Run AWS CLI command to list subscriptions and capture the output
$subscriptionsJson = aws sns list-subscriptions --output json
$subscriptions = $subscriptionsJson | ConvertFrom-Json

# Initialize an array to store the details of each subscription
$subscriptionDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each subscription
foreach ($subscription in $subscriptions.Subscriptions) {
    # Get subscription details
    $subscriptionId = $subscription.SubscriptionArn.Split(":")[-1]
    $endpoint = $subscription.Endpoint
    $protocol = $subscription.Protocol
    $topicArn = $subscription.TopicArn.Split(":")[-1]

    # Add details to the array
    $subscriptionDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Subscription ID' = $subscriptionId
        'Endpoint' = $endpoint
        'Protocol' = $protocol
        'Topic' = $topicArn
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$subscriptionDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'SNS-Sub'