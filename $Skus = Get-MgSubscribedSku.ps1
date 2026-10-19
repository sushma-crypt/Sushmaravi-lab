$Skus = Get-MgSubscribedSku

$Mailboxes = Get-EXOMailbox -ResultSize Unlimited `
    -RecipientTypeDetails UserMailbox

$Report = foreach ($Mailbox in $Mailboxes) {

    $User = Get-MgUser -UserId $Mailbox.UserPrincipalName `
        -Property DisplayName,UserPrincipalName,AssignedLicenses

    $LicenseNames = foreach ($License in $User.AssignedLicenses) {

        $Sku = $Skus | Where-Object {
            $_.SkuId -eq $License.SkuId
        }

        if ($Sku) {
            $Sku.SkuPartNumber
        }
    }

    [PSCustomObject]@{
        DisplayName       = $Mailbox.DisplayName
        UserPrincipalName = $Mailbox.UserPrincipalName
        PrimarySMTP       = $Mailbox.PrimarySmtpAddress
        LicenseName       = ($LicenseNames -join ", ")
    }
}

$Report | Format-Table -AutoSize