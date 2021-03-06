function set_up_db ($db_name, $db_path) {
  # Turn off errors
  $erroractionpreference = 0
  Mount-sqlite -name $db_name -dataSource $db_path
  # Turn errors back on
  $erroractionpreference = 1
  }

function make_table ($db_name, $table_name, $object_type="account") {
  switch ($object_type) {
    "account" { make_column_list $username $object_type
                #(1..2) | foreach-object {"." ; sleep 1}
                #import-module ./modules/column_list.psm1
                #$discard = make_column_command
                Invoke-Expression $mk_act_column_command
                make_act_column_command
                }
    "group"    { #"i would make a group type table here"
                make_column_list "users" $object_type
                #Write-Host $mk_grp_column_command
                Invoke-Expression $mk_grp_column_command
                make_grp_column_command
                }
    }
  }  

function make_demo_table ($db_name, $table_name) {
 New-Item "$db_name`:/$table_name" -id integer primary key -AuditDateStamp text -AccountRemoved text `
 -enabled text -mail text -employeetype text -samaccountname text
 }
  
function write_to_sql ($dbname, $table_name) {
  #"table_name is $table_name"
  switch ($table_name) {
    "GroupTable" { 
      $discard = make_table $dbname $table_name "group" 
      $audit_date = Get-Date
      craft_query $dbname $table_name "group"
      Invoke-Expression $mk_grp_insert_query
      foreach ($group in get_groups) {
        $output = persist_objects $dbname $table_name $group $audit_date "group"
        $output | select id,samaccountname
        }
      }
    "SvcTable" { 
      $discard = make_table $dbname $table_name 
      $audit_date = Get-Date
      craft_query $dbname $table_name
      Invoke-Expression $mk_act_insert_query 
      foreach ($dood in get_svc_objects) { 
        $output = persist_objects $dbname $table_name $dood $audit_date
        $output | select id,samaccountname
        }
      }
    "BangTable" { 
      $discard = make_table $dbname $table_name 
      $audit_date = Get-Date
      craft_query $dbname $table_name
      Invoke-Expression $mk_act_insert_query 
      foreach ($dood in get_bangdot_objects) { 
        $output = persist_objects $dbname $table_name $dood $audit_date
        $output | select id,samaccountname
        }
      }  
    }   
  }

function persist_objects ($db, $table, $object, $auditdate, $object_type="account") {
  switch ($object_type) {
    "account" { make_insert_query $object }
    "group"   {#"I would persist a group type object here"
               # Moving this up to write_to_sql to avoid making the query over and over
               #Invoke-Expression $mk_grp_insert_query
               make_insert_query $object
               }
    }  
  }  

function persist_demo_objects ($db, $table, $object, $auditdate) {
  new-item "$db`:\$table" -AuditDateStamp $auditdate -AccountRemoved "" -enabled $object.enabled `
  -mail $object.mail -employeetype $object.employeetype -samaccountname $object.samaccountname
  }     
 
function craft_query ( $dbname, $table_name, $object_type="account") {
  #"craft query dbname/tablename is $dbname $table_name"
  switch ($object_type) {
    "account" {
      $discard = make_insert_statement $dbname $table_name $object_type
      #(1..2) | foreach-object {"." ; sleep 1}
      #import-module ./modules/insert-query.psm1
      }
    "group" {
      #"I would make a group type insert query here"
      $discard = make_insert_statement $dbname $table_name $object_type
      }
    }
  }
       
function make_column_list ($exemplar, $object_type) {
  Import-Module activedirectory
  switch ($object_type) {
    "account"  {$goodProps = get-aduser -filter { samaccountname -like $exemplar } -properties * | 
                get-member -type property | where { $_.name -notmatch "cert" } | foreach {$_.name}
                }
    "group"    {$goodProps = get-adgroup -filter { samaccountname -like $exemplar } | 
                get-member -type property | foreach {$_.name}
                }
              }

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
  switch ($object_type) {
    "account"  {
      #remove-item ./modules/column_list.psm1
      #"old file removed"
      #(1..2) | foreach-object {"." ; sleep 1}
      #"#$(get-date)`nfunction make_column_command {" > ./modules/column_list.psm1
      #"New-Item `$(`"``$db_name``:/`$table_name`") -id integer primary key -AuditDateStamp text -AccountRemoved text " + $longstring + "`n}" >> ./modules/column_list.psm1
      $script:mk_act_column_command = "function make_act_column_command {New-Item `$(`"``$db_name``:/`$table_name`") -id integer primary key -AuditDateStamp text -AccountRemoved text " + $longstring + "`n}"
      }
    "group"    {
      $script:mk_grp_column_command = "function make_grp_column_command {New-Item `$(`"``$db_name``:/`$table_name`") -id integer primary key -AuditDateStamp text -IsPrivileged integer " + $longstring + "`n}"
      }
    }
  
  }

function make_insert_statement ($dbname, $table_name, $object_type) {
  switch ($object_type) {
    "account"    {$goodProps = get-aduser -filter { samaccountname -like $username } -properties * | 
                   get-member -type property | where { $_.name -notmatch "cert" } | foreach {$_.name}
                  }
    "group"       {$goodProps = get-adgroup -filter { samaccountname -like "users" } | 
                   get-member -type property | foreach {$_.name}
                   }
    }
    
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
  switch ($object_type) {
    "account"    {#remove-item ./modules/insert-query.psm1
                  #"old insert-query file removed"
                  #(1..2) | foreach-object {"." ; sleep 1}
                  #"#$(get-date)`n`$dbname`nfunction make_insert_query (`$object) {" > ./modules/insert-query.psm1
                  #"New-Item `$(`"``$dbname``:/`$table_name`") -AuditDateStamp `$auditdate -AccountRemoved `"`" " + $longstring + "`n}" >> ./modules/insert-query.psm1
                  $script:mk_act_insert_query = "function make_insert_query (`$object) {New-Item `$(`"``$dbname``:/`$table_name`") -AuditDateStamp `$auditdate -AccountRemoved `"`" " + $longstring + "`n}"
                  }
    "group"       { 
                  $script:mk_grp_insert_query = "function make_insert_query (`$object) { New-Item `$(`"``$dbname``:/`$table_name`") -AuditDateStamp `$auditdate -IsPrivileged 4 " + $longstring + "`n}"
                  }
                }
  }

function search_applic ($table_names, $command) {
  ForEach ($table_name in $table_names) {
    "`n`n$table_name --------------------------------------"
    Invoke-Expression "ls `"$read_dbname`:$table_name`" $command"
    } 
  }

function query_db ($db, $table, $column, $value) { ls $db`:/$table -filter "$column like '$value'" }  

function update_db ($db, $table, $id, $column, $value) { set-item $db`:$table\$id -value @{ $column=$value } }

Export-ModuleMember -Function * -Variable *