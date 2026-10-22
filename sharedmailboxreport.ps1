$Report = foreach ($Mailbox in Get-EXOMailbox -RecipientTypeDetails SharedMailbox -ResultSize Unlimited)
{
    $Stats = Get-EXOMailboxStatistics -Identity $Mailbox.UserPrincipalName

    $Members = (Get-EXOMailboxPermission -Identity $Mailbox.UserPrincipalName |
        Where-Object {
            $_.User -notlike "NT AUTHORITY\SELF" -and
            $_.AccessRights -contains "FullAccess"
        }).User -join "; "

    [PSCustomObject]@{
        SharedMailboxName = $Mailbox.DisplayName
        EmailAddress      = $Mailbox.PrimarySmtpAddress
        Size              = $Stats.TotalItemSize
        ItemCount         = $Stats.ItemCount
        Members           = $Members
    }
}

$Report | Export-Csv "C:\Temp\SharedMailboxReport.csv" -NoTypeInformation