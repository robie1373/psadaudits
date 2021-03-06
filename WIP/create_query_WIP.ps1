﻿import-module ./QueryCommands.psm1

function make_column_list {
  Import-Module activedirectory
  $goodProps = get-aduser -filter { samaccountname -like "r-y" } -properties * | 
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
  sleep 5
  "function make_column_command {" > ./column_list.psm1
  "New-Item `"`$db_name``:/`$table_name`" -id integer primary key -AuditDateStamp text -AccountRemoved text " + $longstring + "`n}" >> ./column_list.psm1
  }

make_column_list
retain_window
