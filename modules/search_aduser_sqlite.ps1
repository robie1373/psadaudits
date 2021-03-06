#Import-Module ./QueryCommands.psm1
name_window "Search SQL for AD users"

function show_menu {
  #Write-host "---------------------------------`n"
  Write-host "Accounts with no Employeetype       [1]"
  Write-Host "Disabled accounts                   [2]"
  Write-Host "Contact Info                        [3]"
  Write-Host "Missing contact email               [4]"
  Write-Host "Password Never expires              [5]"
  Write-Host "Misnamed bang and dot accts         [6]"
  Write-Host "Password last changed > x (live)    [7]"
  Write-host "---------------------------------------`n"
  Write-host "What are you looking for?"
}

function get_input {
  #check_for_errors
  show_menu
  $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
  $x.character
  }

check_dbdir

# Select which version of the db to read
Write-Host "Available Databases are:"
dir $dbdir
$read_dbname = Read-Host "Read from which database?"
$read_dbname = $read_dbname.Trim().split('.')[0]  

"`ndbname is $read_dbname`n"

$discard = set_up_db $read_dbname ($dbdir + $read_dbname + ".sqlite")

while (1 -eq 1) {
  #check_for_errors
switch (get_input) {
  "1" { #ls "$read_dbname`:$table_name" -filter "employeetype is null" | foreach-object {(write-host $_.id,"`t",$_.samaccountname)} 
        #$outfile = "NoEmployeeType_" + (get-date -format MMMddyyyy-HHmmss) + ".txt"
        $table_names = "SvcTable", "BangTable"
        $command = "-filter `"employeetype is null`" | foreach-object {(write-host `$_.id,`"``t`",`$_.samaccountname)}"
        search_applic $table_names $command #| tee $dbdir\$outfile
        #"`n*** A copy of the output was saved to $dbdir$outfile ***`n"
        }
  "2" { #ls "$read_dbname`:$table_name" -filter "enabled='False'" | foreach-object {(write-host $_.id,"`t",$_.samaccountname)} 
        #$outfile = "DisabledAccts_" + (get-date -format MMMddyyyy-HHmmss) + ".txt"
        $table_names = "SvcTable", "BangTable"
        $command = "-filter `"enabled='False'`" | foreach-object {(write-host `$_.id,`"``t`",`$_.samaccountname)}"
        search_applic $table_names $command #| tee $dbdir\$outfile
        #"`n*** A copy of the output was saved to $dbdir$outfile ***`n"
        }
  "3" { #ls "$read_dbname`:$table_name" | foreach-object {(write-host $_.samaccountname,"`t`t",$_.mail) } 
        #$outfile = "ContactInfo_" + (get-date -format MMMddyyyy-HHmmss) + ".txt"
        $table_names = "SvcTable", "BangTable"
        $command = " | foreach-object {(write-host `$_.samaccountname,`"``t``t`",`$_.mail) }"
        search_applic $table_names $command #| tee $dbdir\$outfile
        #"`n*** A copy of the output was saved to $dbdir$outfile ***`n"
        }
  "4" { #$outfile = "MissingContactInfo_" + (get-date -format MMMddyyyy-HHmmss) + ".txt"
        $table_names = "SvcTable", "BangTable"
        $command = "-filter `"mail is null`" | foreach-object {(write-host `$_.id,`"``t`",`$_.samaccountname)}"
        search_applic $table_names $command #| tee $dbdir\$outfile
        #"`n*** A copy of the output was saved to $dbdir$outfile ***`n"
        }
  "5" { #$outfile = "PasswordNeverExpires_" + (get-date -format MMMddyyyy-HHmmss) + ".txt"
        $table_names = "SvcTable", "BangTable"
        $command = "-filter `"PasswordNeverExpires='True'`" | ForEach-Object { (Write-Host `$_.id,`"``t`",`$_.samaccountname)}"
        search_applic $table_names $command #| tee $dbdir\$outfile
        #"`n*** A copy of the output was saved to $dbdir$outfile ***`n"
        }
  "6" { $outfile = "MisnamedAccts_" + (get-date -format MMMddyyyy-HHmmss) + ".txt"
        ls "$read_dbname`:BangTable" -filter "samaccountname not like '!%' and samaccountname not like '.%'" | 
          <#ForEach-Object {
            $copy_obj = New-Object System.object
            Copy-Property $_ $copy_obj
            $copy_obj | select id,samaccountname | sort samaccountname 
            }#>
           select id,samaccountname | format-table -auto | Out-String | tee $dbdir\$outfile
          #foreach-object {(write-host $_.id,"`t",$_.samaccountname)} #| tee $dbdir\$outfile
        "`n*** A copy of the output was saved to $dbdir$outfile ***`n"
        }
  "7" { clear-host
        $age = Read-Host "What is the max password age in days?"
        $age = $age.Trim()
        $age = [int]$age
        #$age = $age * -1
        $outfile = "StalePasswords_" + (get-date -format MMMddyyyy-HHmmss) + ".txt"
        find_old_passwords($age) | tee $dbdir\$outfile
        "`n*** A copy of the output was saved to $dbdir$outfile ***`n"
        }
  
  default { "Sorry. That wasn't one of the choices." }
  }
  #"`n*************`nCtrl-c to quit`n*************`n"
  }
  
retain_window