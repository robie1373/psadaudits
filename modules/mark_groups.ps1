name_window "Update privileged groups"

Clear-Host

function show_menu {
  Write-host "Assess 5 unmarked groups               [1]"
  Write-Host "Display groups marked privileged       [2]"
  Write-Host "Display groups marked not privileged   [3]"
  Write-Host "Assess 5 skipped groups                [4]"
  Write-Host "Assess a specific group                [5]"
  Write-host "---------------------------------`n"
  Write-host "What are you looking for?"
}
  
function get_input {
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

$table_name = "GroupTable"

$discard = set_up_db $read_dbname ($dbdir + $read_dbname + ".sqlite")

function update_selection () {
  $title = "Update Group"
  
  $id = Read-Host "Which group id do you want to update? (Enter to skip)"
  $id = $id.Trim()
  $message = "How would you like to mark group ID: " + $id + "?`n"
  $priv = New-Object System.Management.Automation.Host.ChoiceDescription "&Privileged", "Marks the group privileged"
  $notpriv = New-Object System.Management.Automation.Host.ChoiceDescription "&NotPrivileged", "Marks the group as not privileged"
  $skip = New-Object System.Management.Automation.Host.ChoiceDescription "&Skip", "Marks the group to be skipped in future runs"
  $continue = New-Object System.Management.Automation.Host.ChoiceDescription "&Continue without change", "Continue without change"
  $menu = New-Object System.Management.Automation.Host.ChoiceDescription "&Go back to Menu", "Go back to the menu"
  $options = [System.Management.Automation.Host.ChoiceDescription[]]($continue, $priv, $notpriv, $skip, $menu)
  $result = $host.ui.PromptForChoice($title, $message, $options, 0)
  
  switch ($result) {
    0 {"`nYou selected continue without change`n"}
    1 {"`nYou selected privileged`n"
      $update_cmd = "Set-Item " + $read_dbname + ":" + $table_name + " -filter `"id is " + $id + "`" -value @{ isprivileged=1 }"
      $verify_cmd = "ls " + $read_dbname + ":" + $table_name + " -filter `"id is " + $id + "`" | select samaccountname,managedby,isprivileged,id"
      Invoke-Expression $update_cmd
      "`nThe DB now says:`n"
      Invoke-Expression $verify_cmd
      "-------------Unmarked groups:-------------"
      }
    2 {"`nYou selected not priv`n"
      $update_cmd = "Set-Item " + $read_dbname + ":" + $table_name + " -filter `"id is " + $id + "`" -value @{ isprivileged=0 }"
      $verify_cmd = "ls " + $read_dbname + ":" + $table_name + " -filter `"id is " + $id + "`" | select samaccountname,managedby,isprivileged,id"
      Invoke-Expression $update_cmd
      "`nThe DB now says:`n"
      Invoke-Expression $verify_cmd
      "-------------Unmarked groups:-------------"
      }
    3 {"`nYou selected skip`n"
      $update_cmd = "Set-Item " + $read_dbname + ":" + $table_name + " -filter `"id is " + $id + "`" -value @{ isprivileged=2 }"
      $verify_cmd = "ls " + $read_dbname + ":" + $table_name + " -filter `"id is " + $id + "`" | select samaccountname,managedby,isprivileged,id"
      Invoke-Expression $update_cmd
      "`nThe DB now says:`n"
      Invoke-Expression $verify_cmd
      "-------------Unmarked groups:-------------"
      }
    4 {"`nYou selected menu`n"
       break menu
       }
    }
  }

while ($true) {
  switch (get_input) {
  "1" { :menu while ($true) {
          ls $read_dbname`:$table_name -filter "isprivileged is 4" | select -first 5 samaccountname,managedby,isprivileged,id 
          update_selection
          }
        }
  "2" { ls $read_dbname`:$table_name -filter "isprivileged is 1" | select samaccountname,managedby,isprivileged,id 
        }
  "3" { ls $read_dbname`:$table_name -filter "isprivileged is 0" | select samaccountname,managedby,isprivileged,id 
        }        
  "4" { :menu while ($true) {
          ls $read_dbname`:$table_name -filter "isprivileged is 2" | select -first 5 samaccountname,managedby,isprivileged,id 
          update_selection
          }
        }
  "5" {Write-Host "`nMark which SamAccountName? : "
       $group_to_mark = read-host 
       $group_to_mark = $group_to_mark.Trim() 
       $group_to_mark + "`n`n"
       $commnd = "ls " + $read_dbname + ":" + $table_name + " -filter `"samaccountname is '" + $group_to_mark + "'`" | select samaccountname,managedby,isprivileged,id"
       Invoke-Expression $commnd
       update_selection
       }  
  default { "Sorry. That wasn't one of the choices." }
  }
  "`n*************`nCtrl-c to quit`n*************`n"
  }
  
retain_window
