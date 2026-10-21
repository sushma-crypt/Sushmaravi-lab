Get-EXOMailbox -ResultSize Unlimited |
ForEach-Object {
    $Stats = Get-EXOMailboxStatistics -Identity $_.UserPrincipalName

    [PSCustomObject]@{
        DisplayName       = $_.DisplayName
        EmailAddress      = $_.PrimarySmtpAddress
        TotalItemSize     = $Stats.TotalItemSize
        ItemCount         = $Stats.ItemCount
    }
} | Export-Csv "C:\Temp\MailboxReport.csv" -NoTypeInformation