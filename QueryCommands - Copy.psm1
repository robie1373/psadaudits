Import-Module sqlite
Import-Module activedirectory
Import-Module ./setup.psm1

function get_svc_objects {
  #get-aduser -filter { (name -like "svc*") -or (employeetype -like "service") } -properties mail,employeeType,enabled | 
  #  sort -unique | select-object name,samaccountname,mail,employeetype,enabled
  get-aduser -filter { (name -like "svc*") -or (employeetype -like "service") } -properties * | sort -unique
  }

function set_up_db ($db_name, $db_path) {
  # Turn off errors
  $erroractionpreference = 0
  Mount-sqlite -name $db_name -dataSource $db_path
  # Turn errors back on
  $erroractionpreference = 1
  }
  
  
  
  
  
function make_table ($db_name, $table_name) {
 # Use the make_column_list command to generate the string to append to the base statement below.
 # Pro-tip: Manually past and then run the function in a powershell window and redirect the output into a text file. This avoids much work.
 # e.g. make_column_list > column_list.txt
 #New-Item "$db_name`:/$table_name" -id integer primary key -AuditDateStamp text -AccountRemoved text
  #New-Item "$db_name`:/$table_name" -id integer primary key -AuditDateStamp text -AccountRemoved text -AccountExpirationDate text -accountExpires text -AccountLockoutTime text -AccountNotDelegated text -AllowReversiblePasswordEncryption text -BadLogonCount text -badPasswordTime text -badPwdCount text -cpadding text -CannotChangePassword text -CanonicalName text -City text -CN text -co text -codePage text -Company text -Country text -countryCode text -Created text -createTimeStamp text -Deleted text -Department text -Description text -DisplayName text -DistinguishedName text -Division text -DoesNotRequirePreAuth text -EmailAddress text -EmployeeID text -EmployeeNumber text -employeeType text -Enabled text -extensionAttribute12 text -extensionAttribute14 text -Fax text -GivenName text -HomeDirectory text -HomedirRequired text -HomeDrive text -homeMDB text -homeMTA text -HomePage text -HomePhone text -info text -Initials text -instanceType text -isDeleted text -lpadding text -LastBadPasswordAttempt text -LastKnownParent text -lastLogoff text -lastLogon text -LastLogonDate text -lastLogonTimestamp text -legacyExchangeDN text -LockedOut text -lockoutTime text -logonCount text -LogonWorkstations text -mail text -mailNickname text -Manager text -mDBStorageQuota text -mDBUseDefaults text -MNSLogonAccount text -mobile text -MobilePhone text -Modified text -modifyTimeStamp text -msExchHomeServerName text -msExchMailboxGuid text -msExchMailboxSecurityDescriptor text -msExchOmaAdminWirelessEnable text -msExchRBACPolicyLink text -msExchRecipientDisplayType text -msExchRecipientTypeDetails text -msExchUMEnabledFlags text -msExchUMPinChecksum text -msExchUMRecipientDialPlanLink text -msExchUMSpokenName text -msExchUMTemplateLink text -msExchUserAccountControl text -msExchUserCulture text -msExchVersion text -msExchWhenMailboxCreated text -ADName text -nTSecurityDescriptor text -ObjectCategory text -ObjectClass text -ObjectGUID text -objectSid text -Office text -OfficePhone text -Organization text -OtherName text -PasswordExpired text -PasswordLastSet text -PasswordNeverExpires text -PasswordNotRequired text -physicalDeliveryOfficeName text -POBox text -PostalCode text -PrimaryGroup text -primaryGroupID text -ProfilePath text -ProtectedFromAccidentalDeletion text -pwdLastSet text -SamAccountName text -sAMAccountType text -ScriptPath text -sDRightsEffective text -SID text -SmartcardLogonRequired text -sn text -st text -State text -StreetAddress text -Surname text -telephoneNumber text -Title text -TrustedForDelegation text -TrustedToAuthForDelegation text -UseDESKeyOnly text -userAccountControl text -UserPrincipalName text -uSNChanged text -uSNCreated text -whenChanged text -whenCreated text
  make_column_list
  (1..5) | foreach-object {"." ; sleep 1}
  import-module ./column_list.psm1
  make_column_command
  #New-Item "$db_name`:/$table_name" -id integer primary key -AuditDateStamp text -AccountRemoved text -AccountExpirationDate text -accountExpires text -AccountLockoutTime text -AccountNotDelegated text -AllowReversiblePasswordEncryption text -BadLogonCount text -badPasswordTime text -badPwdCount text -cpadding text -CannotChangePassword text -CanonicalName text -City text -CN text -co text -codePage text -Company text -Country text -countryCode text -Created text -createTimeStamp text -Deleted text -Department text -Description text -DisplayName text -DistinguishedName text -Division text -DoesNotRequirePreAuth text -EmailAddress text -EmployeeID text -EmployeeNumber text -employeeType text -Enabled text -extensionAttribute12 text -extensionAttribute14 text -Fax text -GivenName text -HomeDirectory text -HomedirRequired text -HomeDrive text -homeMDB text -homeMTA text -HomePage text -HomePhone text -info text -Initials text -instanceType text -isDeleted text -lpadding text -LastBadPasswordAttempt text -LastKnownParent text -lastLogoff text -lastLogon text -LastLogonDate text -lastLogonTimestamp text -legacyExchangeDN text -LockedOut text -lockoutTime text -logonCount text -LogonWorkstations text -mail text -mailNickname text -Manager text -mDBStorageQuota text -mDBUseDefaults text -MNSLogonAccount text -mobile text -MobilePhone text -Modified text -modifyTimeStamp text -msExchHomeServerName text -msExchMailboxGuid text -msExchMailboxSecurityDescriptor text -msExchOmaAdminWirelessEnable text -msExchRBACPolicyLink text -msExchRecipientDisplayType text -msExchRecipientTypeDetails text -msExchUMEnabledFlags text -msExchUMPinChecksum text -msExchUMRecipientDialPlanLink text -msExchUMSpokenName text -msExchUMTemplateLink text -msExchUserAccountControl text -msExchUserCulture text -msExchVersion text -msExchWhenMailboxCreated text -ADName text -nTSecurityDescriptor text -ObjectCategory text -ObjectClass text -ObjectGUID text -objectSid text -Office text -OfficePhone text -Organization text -OtherName text -PasswordExpired text -PasswordLastSet text -PasswordNeverExpires text -PasswordNotRequired text -physicalDeliveryOfficeName text -POBox text -PostalCode text -PrimaryGroup text -primaryGroupID text -ProfilePath text -ProtectedFromAccidentalDeletion text -pwdLastSet text -SamAccountName text -sAMAccountType text -ScriptPath text -sDRightsEffective text -SID text -SmartcardLogonRequired text -sn text -st text -State text -StreetAddress text -Surname text -telephoneNumber text -Title text -TrustedForDelegation text -TrustedToAuthForDelegation text -UseDESKeyOnly text -userAccountControl text -UserPrincipalName text -uSNChanged text -uSNCreated text -whenChanged text -whenCreated text
  }  

function make_demo_table ($db_name, $table_name) {
 New-Item "$db_name`:/$table_name" -id integer primary key -AuditDateStamp text -AccountRemoved text -enabled text -mail text -employeetype text -samaccountname text
 }
 
function craft_query ( $dbname, $table_name) {
"craft query dbname is $dbname"
  make_insert_statement $dbname $table_name
  (1..5) | foreach-object {"." ; sleep 1}
  import-module ./insert-query.psm1
  }
   
function persist_objects ($db, $table, $object, $auditdate) {
 # Use the make_insert_statement command to generate the string to append to the base statement below
 # Pro-tip: Manually paste and then run the function in a powershell window and redirect the output into a text file. This avoids much work.
 # e.g. make_insert_statement > insert_statement.txt
 #new-item "$db`:\$table -AuditDateStamp $auditdate -AccountRemoved ""   
  <#"db and table are: " + "$db`:\$table"
  new-item "$db`:\$table" -AuditDateStamp $auditdate -AccountRemoved "" -AccountExpirationDate $object.AccountExpirationDate -accountExpires $object.accountExpires -AccountLockoutTime $object.AccountLockoutTime -AccountNotDelegated $object.AccountNotDelegated -AllowReversiblePasswordEncryption $object.AllowReversiblePasswordEncryption -BadLogonCount $object.BadLogonCount -badPasswordTime $object.badPasswordTime -badPwdCount $object.badPwdCount -cpadding $object.c -CannotChangePassword $object.CannotChangePassword -CanonicalName $object.CanonicalName -City $object.City -CN $object.CN -co $object.co -codePage $object.codePage -Company $object.Company -Country $object.Country -countryCode $object.countryCode -Created $object.Created -createTimeStamp $object.createTimeStamp -Deleted $object.Deleted -Department $object.Department -Description $object.Description -DisplayName $object.DisplayName -DistinguishedName $object.DistinguishedName -Division $object.Division -DoesNotRequirePreAuth $object.DoesNotRequirePreAuth -EmailAddress $object.EmailAddress -EmployeeID $object.EmployeeID -EmployeeNumber $object.EmployeeNumber -employeeType $object.employeeType -Enabled $object.Enabled -extensionAttribute12 $object.extensionAttribute12 -extensionAttribute14 $object.extensionAttribute14 -Fax $object.Fax -GivenName $object.GivenName -HomeDirectory $object.HomeDirectory -HomedirRequired $object.HomedirRequired -HomeDrive $object.HomeDrive -homeMDB $object.homeMDB -homeMTA $object.homeMTA -HomePage $object.HomePage -HomePhone $object.HomePhone -info $object.info -Initials $object.Initials -instanceType $object.instanceType -isDeleted $object.isDeleted -lpadding $object.l -LastBadPasswordAttempt $object.LastBadPasswordAttempt -LastKnownParent $object.LastKnownParent -lastLogoff $object.lastLogoff -lastLogon $object.lastLogon -LastLogonDate $object.LastLogonDate -lastLogonTimestamp $object.lastLogonTimestamp -legacyExchangeDN $object.legacyExchangeDN -LockedOut $object.LockedOut -lockoutTime $object.lockoutTime -logonCount $object.logonCount -LogonWorkstations $object.LogonWorkstations -mail $object.mail -mailNickname $object.mailNickname -Manager $object.Manager -mDBStorageQuota $object.mDBStorageQuota -mDBUseDefaults $object.mDBUseDefaults -MNSLogonAccount $object.MNSLogonAccount -mobile $object.mobile -MobilePhone $object.MobilePhone -Modified $object.Modified -modifyTimeStamp $object.modifyTimeStamp -msExchHomeServerName $object.msExchHomeServerName -msExchMailboxGuid $object.msExchMailboxGuid -msExchMailboxSecurityDescriptor $object.msExchMailboxSecurityDescriptor -msExchOmaAdminWirelessEnable $object.msExchOmaAdminWirelessEnable -msExchRBACPolicyLink $object.msExchRBACPolicyLink -msExchRecipientDisplayType $object.msExchRecipientDisplayType -msExchRecipientTypeDetails $object.msExchRecipientTypeDetails -msExchUMEnabledFlags $object.msExchUMEnabledFlags -msExchUMPinChecksum $object.msExchUMPinChecksum -msExchUMRecipientDialPlanLink $object.msExchUMRecipientDialPlanLink -msExchUMSpokenName $object.msExchUMSpokenName -msExchUMTemplateLink $object.msExchUMTemplateLink -msExchUserAccountControl $object.msExchUserAccountControl -msExchUserCulture $object.msExchUserCulture -msExchVersion $object.msExchVersion -msExchWhenMailboxCreated $object.msExchWhenMailboxCreated -ADName $object.Name -nTSecurityDescriptor $object.nTSecurityDescriptor -ObjectCategory $object.ObjectCategory -ObjectClass $object.ObjectClass -ObjectGUID $object.ObjectGUID -objectSid $object.objectSid -Office $object.Office -OfficePhone $object.OfficePhone -Organization $object.Organization -OtherName $object.OtherName -PasswordExpired $object.PasswordExpired -PasswordLastSet $object.PasswordLastSet -PasswordNeverExpires $object.PasswordNeverExpires -PasswordNotRequired $object.PasswordNotRequired -physicalDeliveryOfficeName $object.physicalDeliveryOfficeName -POBox $object.POBox -PostalCode $object.PostalCode -PrimaryGroup $object.PrimaryGroup -primaryGroupID $object.primaryGroupID -ProfilePath $object.ProfilePath -ProtectedFromAccidentalDeletion $object.ProtectedFromAccidentalDeletion -pwdLastSet $object.pwdLastSet -SamAccountName $object.SamAccountName -sAMAccountType $object.sAMAccountType -ScriptPath $object.ScriptPath -sDRightsEffective $object.sDRightsEffective -SID $object.SID -SmartcardLogonRequired $object.SmartcardLogonRequired -sn $object.sn -st $object.st -State $object.State -StreetAddress $object.StreetAddress -Surname $object.Surname -telephoneNumber $object.telephoneNumber -Title $object.Title -TrustedForDelegation $object.TrustedForDelegation -TrustedToAuthForDelegation $object.TrustedToAuthForDelegation -UseDESKeyOnly $object.UseDESKeyOnly -userAccountControl $object.userAccountControl -UserPrincipalName $object.UserPrincipalName -uSNChanged $object.uSNChanged -uSNCreated $object.uSNCreated -whenChanged $object.whenChanged -whenCreated $object.whenCreated
  "This is after the new item"#>
  make_insert_query
  }  

function persist_demo_objects ($db, $table, $object, $auditdate) {
  new-item "$db`:\$table" -AuditDateStamp $auditdate -AccountRemoved "" -enabled $object.enabled -mail $object.mail -employeetype $object.employeetype -samaccountname $object.samaccountname
  }
  
  
  
  
  
  
  
function query_db ($db, $table, $column, $value) { ls $db`:/$table -filter "$column like '$value'" }  
  
function search_ad ( $property, $value) { 
  get-aduser -filter { $property -eq $value } -properties mail,employeeType,enabled | 
      sort -unique | select-object name,samaccountname,mail,employeetype,enabled
  }

function name_window ( $window_name ) {
  $a = (Get-Host).UI.RawUI
  $a.WindowTitle = "$window_name"  
  }

function retain_window {
  Write-Host "`n`n`nPress a key to close window."
  $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")  
  }
  
# Use this to create the crazy big string required to define tables that have almost all of the AD properties
# Copy/paste the results into the make_table function
function make_column_list {
  Import-Module activedirectory
  $goodProps = get-aduser -filter { samaccountname -like "rlutsey" } -properties * | 
    get-member -type property | where { $_.name -notmatch "cert" } | foreach {$_.name}

  $longstring = ""
  $goodprops2 = $goodprops | ForEach-Object { 
     if ($_.length -lt 2) {"$_" + "padding"}  
     elseif ($_ -eq "name") {"ADName"}
     #elseif ($_ -eq "msDS-User-Account-Control-Computed") {}
     elseif ($_ -match "\w-\w") {}
     elseif ($bad_fields -contains $_) {}
     else {"$_"}
     }
  $goodprops3 = $goodprops2 | ForEach-Object {"-$_ text"}
  $longstring = "$goodprops3"
  $longstring
  remove-item ./column_list.psm1
  "old file removed"
  (1..5) | foreach-object {"." ; sleep 1}
  "#$(get-date)`nfunction make_column_command {" > ./column_list.psm1
  "New-Item `$(`"``$db_name``:/`$table_name`") -id integer primary key -AuditDateStamp text -AccountRemoved text " + $longstring + "`n}" >> ./column_list.psm1
  }

# Use this to create the crazy big string required to insert records into tables with the persist_objects function
# Copy/paste the results into the persist_object's new-item command
function make_insert_statement ($dbname, $table_name) {
  $goodProps = get-aduser -filter { samaccountname -like "rlutsey" } -properties * | 
    get-member -type property | where { $_.name -notmatch "cert" } | foreach {$_.name}

  $longstring = ""
  $goodprops2 = $goodprops | ForEach-Object { 
     if ($_.length -lt 2) {"$_" + "padding"}  
     elseif ($_ -eq "name") {"ADName"}
     #elseif ($_ -eq "msDS-User-Account-Control-Computed") {}
     elseif ($_ -match "\w-\w") {}
     else {"$_"}
     }
  $goodprops3 = $goodprops2 | ForEach-Object {
       if ($_ -eq "ADName") { "-$_ `"`$object." + ($_ -replace 'AD', '') + "`"" }
       else { "-$_ `"`$object." + ($_ -replace 'padding', '') + "`"" }
       }
  $longstring = "$goodprops3"
  $longstring
  remove-item ./insert-query.psm1
  "old insert-query file removed"
  (1..5) | foreach-object {"." ; sleep 1}
  "#$(get-date)`n`$dbname`nfunction make_insert_query {" > ./insert-query.psm1
  "New-Item `$(`"``$dbname``:/`$table_name`") -AuditDateStamp `$auditdate -AccountRemoved `"`" " + $longstring + "`n}" >> ./insert-query.psm1
  }





Export-ModuleMember -Function * -Variable *