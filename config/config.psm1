$version = "0.5.1"
$script:dbname = "ADAuditDB_" + (get-date -format MMMddyyyy-HHmmss)
$script:dbdir = [Environment]::GetFolderPath("MyDocuments") + "\AD_Audits\"
$script:dbpath = $dbdir + "$dbname.sqlite"
$script:username = $env:username


# Don't remove things from $bad_fields unless you know what you are doing. It will cause errors.
# Also ignored is anything with a 'dash' - in it. That blows up sqlite.
$bad_fields = "publicDelegatesBL","publicDelegates", "msExchHomeServerName", "msExchMailboxSecurityDescriptor", "msExchOmaAdminWirelessEnable", "msExchRBACPolicyLink", "msExchRecipientDisplayType", "msExchRecipientTypeDetails", "msExchUMEnabledFlags", "msExchUMRecipientDialPlanLink", "msExchUMTemplateLink", "msExchUMSpokenName", "msExchUMPinChecksum", "msExchMailboxGuid", "co", "managedObjects", "dSCorePropagationData", "MemberOf", "msExchPoliciesIncluded", "msExchUMDtmfMap", "protocolSettings","proxyAddresses", "ServicePrincipalNames", "showInAddressBook", "SIDHistory"

# Use $unwanted_fields to ignore object properties that you don't want to save. Anything you can put here helps performance.
$unwanted_fields = "msExchUserAccountControl", "msExchUserCulture", "msExchVersion", "msExchWhenMailboxCreated"

Export-ModuleMember -Variable *