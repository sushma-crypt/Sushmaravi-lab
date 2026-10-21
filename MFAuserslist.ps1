Connect-MgGraph -Scopes "User.Read.All","AuditLog.Read.All","Directory.Read.All"

$MFAUsers = Get-MgReportAuthenticationMethodUserRegistrationDetail

$Result = foreach($User in $MFAUsers){
    $UserInfo = Get-MgUser -UserId $User.Id -Property DisplayName,UserPrincipalName

    [PSCustomObject]@{
        DisplayName       = $UserInfo.DisplayName
        UserPrincipalName = $UserInfo.UserPrincipalName
        IsMFARegistered   = $User.IsMfaRegistered
        IsMFACapable      = $User.IsMfaCapable
        IsAdmin           = $User.IsAdmin
    }
}

$Result | Format-Table -AutoSize