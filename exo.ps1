# =====================================================================
# Exchange Online Assessment Script
# Author: Sushma Ravi
# Version: 1.0
# =====================================================================

# Connect Exchange Online
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline

# Output Folder
$Date = Get-Date -Format "yyyyMMdd_HHmmss"
$OutputFolder = "C:\EXO_Assessment_$Date"

New-Item -ItemType Directory -Path $OutputFolder -Force | Out-Null

Write-Host "Exporting data to: $OutputFolder" -ForegroundColor Green

# =====================================================================
# Accepted Domains
# =====================================================================

Get-AcceptedDomain |
Export-Csv "$OutputFolder\AcceptedDomains.csv" -NoTypeInformation

# =====================================================================
# User Mailboxes
# =====================================================================

Get-EXOMailbox -ResultSize Unlimited -RecipientTypeDetails UserMailbox |
Select-Object DisplayName,
              UserPrincipalName,
              PrimarySmtpAddress,
              Alias,
              Department,
              Title,
              Company,
              Office,
              ArchiveStatus,
              LitigationHoldEnabled,
              WhenCreatedUTC |
Export-Csv "$OutputFolder\UserMailboxes.csv" -NoTypeInformation

# =====================================================================
# Shared Mailboxes
# =====================================================================

Get-EXOMailbox -ResultSize Unlimited -RecipientTypeDetails SharedMailbox |
Select-Object DisplayName,
              PrimarySmtpAddress,
              WhenCreatedUTC,
              ArchiveStatus |
Export-Csv "$OutputFolder\SharedMailboxes.csv" -NoTypeInformation

# =====================================================================
# Room Mailboxes
# =====================================================================

Get-EXOMailbox -ResultSize Unlimited -RecipientTypeDetails RoomMailbox |
Export-Csv "$OutputFolder\RoomMailboxes.csv" -NoTypeInformation

# =====================================================================
# Equipment Mailboxes
# =====================================================================

Get-EXOMailbox -ResultSize Unlimited -RecipientTypeDetails EquipmentMailbox |
Export-Csv "$OutputFolder\EquipmentMailboxes.csv" -NoTypeInformation

# =====================================================================
# Mailbox Statistics
# =====================================================================

$MailboxStats = foreach ($Mailbox in Get-EXOMailbox -ResultSize Unlimited)
{
    try
    {
        Get-EXOMailboxStatistics $Mailbox.UserPrincipalName |
        Select DisplayName,
               TotalItemSize,
               ItemCount,
               DeletedItemCount,
               LastLogonTime
    }
    catch {}
}

$MailboxStats |
Export-Csv "$OutputFolder\MailboxStatistics.csv" -NoTypeInformation

# =====================================================================
# Mailbox Permissions
# =====================================================================

$Permissions = foreach ($Mailbox in Get-EXOMailbox -ResultSize Unlimited)
{
    Get-MailboxPermission $Mailbox.UserPrincipalName |
    Where {$_.User -notlike "NT AUTHORITY*"} |
    Select Identity,
           User,
           AccessRights,
           IsInherited
}

$Permissions |
Export-Csv "$OutputFolder\MailboxPermissions.csv" -NoTypeInformation

# =====================================================================
# Send-As Permissions
# =====================================================================

$SendAs = foreach ($Mailbox in Get-EXOMailbox -ResultSize Unlimited)
{
    Get-RecipientPermission $Mailbox.UserPrincipalName |
    Select Identity,
           Trustee,
           AccessRights
}

$SendAs |
Export-Csv "$OutputFolder\SendAsPermissions.csv" -NoTypeInformation

# =====================================================================
# Forwarding Configuration
# =====================================================================

Get-EXOMailbox -ResultSize Unlimited |
Select DisplayName,
       UserPrincipalName,
       ForwardingAddress,
       ForwardingSmtpAddress,
       DeliverToMailboxAndForward |
Export-Csv "$OutputFolder\ForwardingSettings.csv" -NoTypeInformation

# =====================================================================
# Distribution Groups
# =====================================================================

Get-DistributionGroup -ResultSize Unlimited |
Select DisplayName,
       Alias,
       PrimarySmtpAddress,
       ManagedBy |
Export-Csv "$OutputFolder\DistributionGroups.csv" -NoTypeInformation

# =====================================================================
# Distribution Group Members
# =====================================================================

$DGMembers = foreach ($DG in Get-DistributionGroup -ResultSize Unlimited)
{
    Get-DistributionGroupMember $DG.Identity |
    Select @{
                Name="GroupName"
                Expression={$DG.DisplayName}
           },
           DisplayName,
           PrimarySmtpAddress,
           RecipientType
}

$DGMembers |
Export-Csv "$OutputFolder\DistributionGroupMembers.csv" -NoTypeInformation

# =====================================================================
# Dynamic Distribution Groups
# =====================================================================

Get-DynamicDistributionGroup -ResultSize Unlimited |
Export-Csv "$OutputFolder\DynamicDistributionGroups.csv" -NoTypeInformation

# =====================================================================
# Microsoft 365 Groups
# =====================================================================

Get-UnifiedGroup -ResultSize Unlimited |
Select DisplayName,
       Alias,
       PrimarySmtpAddress,
       AccessType |
Export-Csv "$OutputFolder\M365Groups.csv" -NoTypeInformation

# =====================================================================
# Mail Contacts
# =====================================================================

Get-MailContact -ResultSize Unlimited |
Select Name,
       Alias,
       ExternalEmailAddress |
Export-Csv "$OutputFolder\MailContacts.csv" -NoTypeInformation

# =====================================================================
# Mail Users
# =====================================================================

Get-MailUser -ResultSize Unlimited |
Select Name,
       UserPrincipalName,
       ExternalEmailAddress |
Export-Csv "$OutputFolder\MailUsers.csv" -NoTypeInformation

# =====================================================================
# Mail Flow Rules
# =====================================================================

Get-TransportRule |
Export-Csv "$OutputFolder\TransportRules.csv" -NoTypeInformation

# =====================================================================
# Inbound / Outbound Connectors
# =====================================================================

Get-InboundConnector |
Export-Csv "$OutputFolder\InboundConnectors.csv" -NoTypeInformation

Get-OutboundConnector |
Export-Csv "$OutputFolder\OutboundConnectors.csv" -NoTypeInformation

# =====================================================================
# Remote Domains
# =====================================================================

Get-RemoteDomain |
Export-Csv "$OutputFolder\RemoteDomains.csv" -NoTypeInformation

# =====================================================================
# Tenant Summary
# =====================================================================

$Summary = [PSCustomObject]@{
    UserMailboxes      = (Get-EXOMailbox -RecipientTypeDetails UserMailbox -ResultSize Unlimited).Count
    SharedMailboxes    = (Get-EXOMailbox -RecipientTypeDetails SharedMailbox -ResultSize Unlimited).Count
    RoomMailboxes      = (Get-EXOMailbox -RecipientTypeDetails RoomMailbox -ResultSize Unlimited).Count
    EquipmentMailboxes = (Get-EXOMailbox -RecipientTypeDetails EquipmentMailbox -ResultSize Unlimited).Count
    DGs                = (Get-DistributionGroup -ResultSize Unlimited).Count
    M365Groups         = (Get-UnifiedGroup -ResultSize Unlimited).Count
    MailContacts       = (Get-MailContact -ResultSize Unlimited).Count
}

$Summary |
Export-Csv "$OutputFolder\TenantSummary.csv" -NoTypeInformation

Write-Host ""
Write-Host "Exchange Online Assessment Completed Successfully" -ForegroundColor Green
Write-Host "Output Folder: $OutputFolder" -ForegroundColor Yellow