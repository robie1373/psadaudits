Import-Module sqlite
Import-Module activedirectory
Import-Module ./config.psm1

function get_svc_objects {
  #get-aduser -filter { (name -like "svc*") -or (employeetype -like "service") } -properties mail,employeeType,enabled | 
  #  sort -unique | select-object name,samaccountname,mail,employeetype,enabled
  get-aduser -filter { (name -like "svc*") -or (employeetype -like "service") } -properties * | sort -unique
  }

function get_bangdot_objects {
  get-aduser -filter { (employeetype -like "admin") -or (samaccountname -like "!*") -or (samaccountname -like ".*") } -properties * | 
  sort -unique 
  }
  
function get_groups {
  get-adgroups -filter * 
  }

function check_dbdir {
  if (Test-Path $dbdir) { "$dbdir looks good. Moving on." }
  else { 
    "`n***WARNING***`n$dbdir does not exist. You should create it." 
    "This window will close in 60 seconds"
    sleep 60
    break
    }
  }
  
function set_up_db ($db_name, $db_path) {
  # Turn off errors
  $erroractionpreference = 0
  Mount-sqlite -name $db_name -dataSource $db_path
  # Turn errors back on
  $erroractionpreference = 1
  }
  
function write_to_sql ($dbname, $table_name) {
  #"table_name is $table_name"
  switch ($table_name) {
    "GroupTable" { 
      $discard = make_table $dbname $table_name "group" 
      $audit_date = Get-Date
      # craft insert query here
      foreach ($group in get_groups) {
        $output = persist_objects $dbname $table_name $group $audit_date "group"
        $output | select id,samaccountname
        }
      }
    "SvcTable" { 
      $discard = make_table $dbname $table_name 
      $audit_date = Get-Date
      craft_query $dbname $table_name
      foreach ($dood in get_svc_objects) { 
        $output = persist_objects $dbname $table_name $dood $audit_date
        $output | select id,samaccountname
        }
      }
    "BangTable" { 
      make_table $dbname $table_name 
      $audit_date = Get-Date
      craft_query $dbname $table_name
      foreach ($dood in get_bangdot_objects) { 
        $output = persist_objects $dbname $table_name $dood $audit_date
        $output | select id,samaccountname
        }
      }  
    }   
  }
  
  
  
function make_table ($db_name, $table_name, $object_type="account") {
  switch ($object_type) {
    "account" { make_column_list
                (1..2) | foreach-object {"." ; sleep 1}
                import-module ./column_list.psm1
                $discard = make_column_command
                }
    "group" { "i would make a group type table here" }
    }
  }  

function make_demo_table ($db_name, $table_name) {
 New-Item "$db_name`:/$table_name" -id integer primary key -AuditDateStamp text -AccountRemoved text `
 -enabled text -mail text -employeetype text -samaccountname text
 }
 
function craft_query ( $dbname, $table_name, $object_type="account") {
  #"craft query dbname/tablename is $dbname $table_name"
  switch ($object_type) {
    "account" {
      $discard = make_insert_statement $dbname $table_name
      (1..2) | foreach-object {"." ; sleep 1}
      import-module ./insert-query.psm1
      }
    "group" {
      "I would make a group type insert query here"
      }
    }
  }
   
function persist_objects ($db, $table, $object, $auditdate, $object_type="account") {
  switch ($object_type) {
    "account" { make_insert_query $object }
    "group"   { "I would persist a group type object here" }
    }  
  }  

function persist_demo_objects ($db, $table, $object, $auditdate) {
  new-item "$db`:\$table" -AuditDateStamp $auditdate -AccountRemoved "" -enabled $object.enabled `
  -mail $object.mail -employeetype $object.employeetype -samaccountname $object.samaccountname
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
  Write-Host "`n`n`nCtrl-c to close window."
  $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")  
  }
  
function make_column_list {
  Import-Module activedirectory
  $goodProps = get-aduser -filter { samaccountname -like $username } -properties * | 
    get-member -type property | where { $_.name -notmatch "cert" } | foreach {$_.name}

  $longstring = ""
  $goodprops2 = $goodprops | ForEach-Object { 
     if ($_.length -lt 2) {"$_" + "padding"}  
     elseif ($_ -eq "name") {"ADName"}
     #elseif ($_ -eq "msDS-User-Account-Control-Computed") {}
     #TODO next line commented out to cause errors. Fix before useing
     elseif ($_ -match "\w-\w") {}
     elseif ($bad_fields -contains $_) {}
     elseif ($unwanted_fields -contains $_) {}
     else {"$_"}
     }
  $goodprops3 = $goodprops2 | ForEach-Object {"-$_ text"}
  $longstring = "$goodprops3"
  $longstring
  # This was before I found Invoke-Expression. Shrug
  remove-item ./column_list.psm1
  "old file removed"
  (1..2) | foreach-object {"." ; sleep 1}
  "#$(get-date)`nfunction make_column_command {" > ./column_list.psm1
  "New-Item `$(`"``$db_name``:/`$table_name`") -id integer primary key -AuditDateStamp text -AccountRemoved text " + $longstring + "`n}" >> ./column_list.psm1
  }

function make_insert_statement ($dbname, $table_name) {
  $goodProps = get-aduser -filter { samaccountname -like $username } -properties * | 
    get-member -type property | where { $_.name -notmatch "cert" } | foreach {$_.name}

  $longstring = ""
  $goodprops2 = $goodprops | ForEach-Object { 
     if ($_.length -lt 2) {"$_" + "padding"}  
     elseif ($_ -eq "name") {"ADName"}
     #elseif ($_ -eq "msDS-User-Account-Control-Computed") {}
     #TODO next line commented out to cause errors. Fix before useing
     elseif ($_ -match "\w-\w") {}
     elseif ($bad_fields -contains $_) {}
     elseif ($unwanted_fields -contains $_) {}
     else {"$_"}
     }
  $goodprops3 = $goodprops2 | ForEach-Object {
       if ($_ -eq "ADName") { "-$_ `$object." + ($_ -replace 'AD', '') }
       else { "-$_ `$object." + ($_ -replace 'padding', '') }
       }
  $longstring = "$goodprops3"
  $longstring
  # This was before I found Invoke-Expression. Shrug
  remove-item ./insert-query.psm1
  "old insert-query file removed"
  (1..2) | foreach-object {"." ; sleep 1}
  "#$(get-date)`n`$dbname`nfunction make_insert_query (`$object) {" > ./insert-query.psm1
  "New-Item `$(`"``$dbname``:/`$table_name`") -AuditDateStamp `$auditdate -AccountRemoved `"`" " + $longstring + "`n}" >> ./insert-query.psm1
  }





Export-ModuleMember -Function * -Variable *