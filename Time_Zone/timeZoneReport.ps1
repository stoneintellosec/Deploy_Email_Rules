$users = Get-Mailbox -ResultSize Unlimited

$report = $users | ForEach-Object {
    $regional = Get-MailboxRegionalConfiguration -Identity $_.Identity
    [PSCustomObject]@{
        DisplayName = $_.DisplayName
        UserPrincipalName = $_.UserPrincipalName
        TimeZone = $regional.TimeZone
        Language = $regional.Language
        DateFormat = $regional.DateFormat
        TimeFormat = $regional.TimeFormat
    }
}

 $date = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

# Export to CSV
$report | Export-Csv -Path "${date}_MailboxRegionalConfig.csv" -NoTypeInformation