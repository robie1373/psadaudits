Import-Module activedirectory

function find_old_passwords ($age) {
  "`nThese accounts do not have a PasswordLastSet attribute. That is fishy."
  get_svc_objects | where { $_.passwordlastset -eq $null } | select samaccountname,passwordage,passwordlastset,mail,enabled
  
  "`n`nThese accounts' PasswordLastSet date is more than $age days ago.`n"
  <#get_svc_objects | foreach-object { 
    if ($_.passwordlastset -ne $null) {
       $password_age = ( (get-date) - $_.passwordlastset ).days
       if ($password_age -ge $age) {
        #"--------------------------------------------------------"
        $_.samaccountname + " password is " + $password_age + " days old`n"
        "Account:            " + $_.samaccountname
        "Contact:            " + $_.mail
        "PasswordLastSet:    " + $_.passwordlastset
        "Enabled:          " + $_.Enabled
        #$_ | select samaccountname,mail,passwordlastset
        "--------------------------------------------------------"
        }
      }
    }#>
  get_svc_objects | add_password_age | where {$_.passwordage -gt $age} |  
    sort -property passwordage -descending |
      foreach {
        "--------------------------------------------------------`n" + $_.samaccountname + " password is " + $_.passwordage + " days old"
        $_
      } 
  }
  