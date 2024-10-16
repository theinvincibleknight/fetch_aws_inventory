# Run AWS CLI command to list ACM certificates and capture the output
$acmCertificatesJson = aws acm list-certificates --output json
$acmCertificates = $acmCertificatesJson | ConvertFrom-Json

# Initialize an array to store the details of each ACM certificate
$acmDetails = @()

# Initialize a counter for serial numbers
$serialNumber = 1

# Iterate over each ACM certificate
foreach ($certificate in $acmCertificates.CertificateSummaryList) {
    # Add details to the array
    $acmDetails += [PSCustomObject]@{
        'Sr. No.' = $serialNumber++
        'Certificate ID' = $certificate.CertificateArn
        'Domain name' = $certificate.DomainName
        'Type' = $certificate.Type
        'Status' = $certificate.Status
        'In use' = $certificate.InUse
        'Renewal eligibility' = $certificate.RenewalEligibility
        'Key algorithm' = $certificate.KeyAlgorithm
        'Region' = $certificate.CertificateArn.Split(':')[3]
    }
}

# Export the details to an Excel file
$exportPath = "C:\Users\Akshay Hegde\Downloads\Files\AWS_Inventory.xlsx"
$acmDetails | Export-Excel -Path $exportPath -AutoSize -BoldTopRow -WorksheetName 'CertificateManager'