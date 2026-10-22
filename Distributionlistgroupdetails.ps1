$Report = foreach ($DG in Get-DistributionGroup -ResultSize Unlimited)
{
    $Owners = foreach ($Owner in $DG.ManagedBy)
    {
        (Get-Recipient $Owner).DisplayName
    }

    $Members = foreach ($Member in Get-DistributionGroupMember -Identity $DG.Identity)
    {
        $Member.PrimarySmtpAddress
    }

    [PSCustomObject]@{
        DGName       = $DG.DisplayName
        EmailAddress = $DG.PrimarySmtpAddress
        Owners       = ($Owners -join "; ")
        Members      = ($Members -join "; ")
        MemberCount  = $Members.Count
    }
}

$Report | Export-Csv "C:\Temp\DistributionGroupReport.csv" -NoTypeInformation