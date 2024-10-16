# Run AWS CLI command to list Amazon MQ brokers and capture the output
$mqBrokersJson = aws mq list-brokers --output json
$mqBrokers = $mqBrokersJson | ConvertFrom-Json

# Initialize an array to store the details of each Amazon MQ broker
$mqBrokerDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each Amazon MQ broker
foreach ($broker in $mqBrokers.BrokerSummaries) {
    # Get broker details
    $brokerDetailsJson = aws mq describe-broker --broker-id $broker.BrokerId --output json
    $brokerDetails = $brokerDetailsJson | ConvertFrom-Json

    # Get endpoint
    $endpoint = $brokerDetails.BrokerInstances[0].Endpoints[0]

    # Get availability zone
    #$availabilityZone = $brokerDetails.BrokerInstances[0].AvailabilityZone

    # Add details to the array
    $mqBrokerDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Broker Name' = $broker.BrokerName
        'Broker Instance Type' = $broker.HostInstanceType
        'Broker Engine' = $broker.EngineType
        'Broker Engine Version' = $brokerDetails.EngineVersion
        'Endpoint' = $endpoint
        'Availability Zone' = $broker.BrokerArn.Split(':')[3]
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$mqBrokerDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'MQ_Broker'