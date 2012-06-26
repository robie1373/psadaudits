name_window "Update privy groups"

Clear-Host

function show_menu {
  #Write-host "---------------------------------`n"
  Write-host "Assess 10 unmarked groups              [1]"
  Write-Host "Display groups marked privileged       [2]"
  Write-Host "Display groups marked not privileged   [3]"
  Write-Host "Assess 10 skipped groups               [4]"
  Write-Host "Assess a specific group                [5]"
  Write-host "---------------------------------`n"
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
$read_dbname = Read-Host "Work on which database?"
$read_dbname = $read_dbname.Trim().split('.')[0]  

"`ndbname is $read_dbname`n"

$discard = set_up_db $read_dbname ($dbdir + $read_dbname + ".sqlite")

while (1 -eq 1) {
  #check_for_errors
switch (get_input) {
  "1" { $table_name = "GroupTable"
        ls $read_dbname`:$table_name -filter `"IsPrivileged=0`" #| select -first 10 samaccountname,managedby,isprivileged
        #$command = "-filter `"IsPrivileged=0`" | select -first 10 samaccountname,managedby,isprivileged | format-table -auto"
        #search_applic $table_names $command
        }
  <#"2" { $table_names = "SvcTable", "BangTable"
        $command = "-filter `"enabled='False'`" | foreach-object {(write-host `$_.id,`"``t`",`$_.samaccountname)}"
        search_applic $table_names $command
        }
  "3" { $table_names = "SvcTable", "BangTable"
        $command = " | foreach-object {(write-host `$_.samaccountname,`"``t``t`",`$_.mail) }"
        search_applic $table_names $command
        }
  "4" { $table_names = "SvcTable", "BangTable"
        $command = "-filter `"mail is null`" | foreach-object {(write-host `$_.id,`"``t`",`$_.samaccountname)}"
        search_applic $table_names $command
        }
  "5" { $table_names = "SvcTable", "BangTable"
        $command = "-filter `"PasswordNeverExpires='True'`" | ForEach-Object { (Write-Host `$_.id,`"``t`",`$_.samaccountname)}"
        search_applic $table_names $command
        }
  "6" { ls "$read_dbname`:BangTable" -filter "samaccountname not like '!%' and samaccountname not like '.%'" | foreach-object {(write-host $_.id,"`t",$_.samaccountname)} }
  #>
  default { "Sorry. That wasn't one of the choices." }
  }
  #"`n*************`nCtrl-c to quit`n*************`n"
  }
  
retain_window

<#
function search_applic ($table_names, $command) {
  ForEach ($table_name in $table_names) {
    "`n`n$table_name --------------------------------------"
    Invoke-Expression "ls `"$read_dbname`:$table_name`" $command"
    }
  }
  #>