Exchange Online

======================================================================================================================



**Connect to Exchange Online:**

Connect-ExchangeOnline



Start-Transcript 





**Organization Configuration:**



Get-OrganizationConfig







**Accepted Domains:**

Get-AcceptedDomain





**Remote Domains:**

Get-RemoteDomain





**OrganizationRelationships:**



Get-OrganizationRelationship



Get-OrganizationRelationship | Format-List \*



Get-OrganizationRelationship | Select Name,DomainNames,Enabled,FreeBusyAccessEnabled,MailboxMoveEnabled







**Sharing Policies:**

Get-SharingPolicy







**Address Book Policies:**



Get-AddressBookPolicy





**Transport Rules:**



Get-TransportRule





**Inbound Connectors:**



Get-InboundConnector

Get-InboundConnector | Format-List \*



**Outbound Connectors:**



Get-OutboundConnector



Get-OutboundConnector | Format-List \*





&#x20;

**User Mailboxes:**

Get-EXOMailbox -RecipientTypeDetails UserMailbox



**UserMailbox Shared Mailboxes:**

Get-EXOMailbox -RecipientTypeDetails SharedMailbox



**Room Mailboxes:**

Get-EXOMailbox -RecipientTypeDetails RoomMailbox



**Equipment Mailboxes:**

Get-EXOMailbox -RecipientTypeDetails EquipmentMailbox



**Get all mailboxes with key properties**

Get-EXOMailbox | Select DisplayName,PrimarySmtpAddress,RecipientTypeDetails,WhenCreated



&#x20;

**Distribution Lists:**

Get-DistributionGroup



Mail-enabled Security Groups:

Get-DistributionGroup | Format-List \*



Get-DistributionGroup | Select DisplayName,PrimarySmtpAddress,Alias,ManagedBy



Get-DistributionGroup | ForEach-Object {

&#x20;   Get-DistributionGroupMember -Identity $\_.Identity

}







**MailUniversalSecurityGroup Microsoft 365 Groups:**

Get-UnifiedGroup



**Mailbox Statistics:**

Get-EXOMailbox -RecipientTypeDetails UserMailbox | Get-EXOMailboxStatistics



Get-EXOMailbox -RecipientTypeDetails UserMailbox |

Get-EXOMailboxStatistics |

Select DisplayName,ItemCount,TotalItemSize,LastLogonTime,LastLoggedOnUserAccount |

Export-Csv -Path "C:\\Reports\\UserMailboxStatistics.csv" -NoTypeInformation -Encoding UTF8







**Mailbox Quotas:**

Get-EXOMailbox | Select DisplayName,ProhibitSendQuota,ProhibitSendReceiveQuota



Get-EXOMailbox |

Select DisplayName, ProhibitSendQuota, ProhibitSendReceiveQuota |

Export-Csv -Path "C:\\Reports\\MailboxQuotaReport.csv" -NoTypeInformation -Encoding UTF8









**Archive Status:**

Get-EXOMailbox | Select DisplayName,ArchiveStatus



Get-EXOMailbox |

Select DisplayName, ArchiveStatus |

Export-Csv -Path "C:\\Reports\\MailboxArchiveStatus.csv" -NoTypeInformation -Encoding UTF8







**Litigation Hold:**



Get-EXOMailbox | Select DisplayName, LitigationHoldEnabled, RetentionPolicy



Get-EXOMailbox |

Select DisplayName, LitigationHoldEnabled, RetentionPolicy |

Export-Csv -Path "C:\\Reports\\Mailbox\_LitigationHold\_RetentionPolicy.csv" -NoTypeInformation -Encoding UTF8



Get-EXOMailbox |

Select DisplayName, LitigationHoldEnabled, RetentionHoldEnabled, RetentionPolicy



Get-EXOMailbox |

Select DisplayName, LitigationHoldEnabled, RetentionHoldEnabled, RetentionPolicy |

Export-Csv -Path "C:\\Reports\\Mailbox\_Hold\_Retention\_Report.csv" -NoTypeInformation -Encoding UTF8



&#x20;



**Hold:**

Get-EXOMailbox | Select DisplayName,RetentionHoldEnabled



**Mailbox Auditing:**

Get-EXOMailbox | Select DisplayName,AuditEnabled



**Mailbox Permissions:**

Get-EXOMailbox | Get-EXOMailboxPermission



Get-EXOMailbox |

Get-EXOMailboxPermission |

Select Identity, User, AccessRights, IsInherited, Deny |

Export-Csv -Path "C:\\Reports\\MailboxPermissions.csv" -NoTypeInformation -Encoding UTF8







**Send As Permissions:**

Get-RecipientPermission

&#x20;

**Full Access Permissions:**

Get-EXOMailbox | Get-EXOMailboxPermission



Get-EXOMailbox |

Get-EXOMailboxPermission |

Select Identity, User, AccessRights, IsInherited, Deny |

Export-Csv -Path "C:\\Reports\\MailboxPermissions.csv" -NoTypeInformation -Encoding UTF8





&#x20;

**Auto Forwarding:**

Get-EXOMailbox | Select DisplayName,ForwardingSMTPAddress,DeliverToMailboxAndForward



**Message Trace:**

Get-MessageTrace



+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



**SharePoint Online**



Connect:



Connect-SPOService -Url https://m365x92876771-admin.sharepoint.com -UseSystemBrowser $true









**Tenant Settings:**



Get-SPOTenant



&#x20;

**All Site Collections:**

Get-SPOSite



**Team Sites:**

Get-SPOSite -Template GROUP#0

&#x20;

**Communication Sites:**

Get-SPOSite -Template SITEPAGEPUBLISHING#0





**Hub Sites:**

Get-SPOHubSite





**Site Owners:**

Get-SPOSite | Select Url,Owner

&#x20;

**Site Storage:**

Get-SPOSite | Select Url,StorageUsageCurrent

&#x20;

**Sharing Capability:**

Get-SPOSite | Select Url,SharingCapability



**Site Templates:**

Get-SPOSite | Select Url,Template



++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



OneDrive for Business



**OneDrive Sites:**



Get-SPOSite -IncludePersonalSite $true -Limit All -Template SPSPERS



**OneDrive Storage:**

Get-SPOSite -IncludePersonalSite $true | Select Url,StorageUsageCurrent



**OneDrive Owners:**

Get-SPOSite -IncludePersonalSite $true | Select Url,Owner



++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



**Microsoft Teams**



**Connect:**

Connect-MicrosoftTeams





**Teams Org Configuration:**

Get-CsTeamsClientConfiguration





**External Access:**

Get-CsExternalAccessPolicy

&#x20;

**Teams Upgrade Mode:**

Get-CsTeamsUpgradePolicy



**Messaging Policies:**

Get-CsTeamsMessagingPolicy

&#x20;

**Meeting Policies:**

Get-CsTeamsMeetingPolicy

&#x20;

**Calling Policies:**

Get-CsTeamsCallingPolicy



**Live**



**Events Policies:**



Get-CsTeamsEventsPolicy



&#x20;

**App Permission Policies:**

Get-CsTeamsAppPermissionPolicy



**App Setup Policies:**

Get-CsTeamsAppSetupPolicy

&#x20;

**All Teams:**

Get-Team



**Team Users:**



Get-Team | ForEach-Object { Get-TeamUser -GroupId $\_.GroupId }



**Archived Teams:**

Get-Team | Where-Object {$\_.Archived -eq $true}



++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



**Microsoft Graph**



**Connect:**

Connect-MgGraph -Scopes Reports.Read.All,Directory.Read.All





**License Summary:**

Get-MgSubscribedSku



**User Count:**

Get-MgUser -All



**Service Health:**

Get-MgServiceAnnouncementHealthOverview

&#x20;

**Service Health Issues:**

Get-MgServiceAnnouncementIssue



**Message Center:**

Get-MgServiceAnnouncementMessage

