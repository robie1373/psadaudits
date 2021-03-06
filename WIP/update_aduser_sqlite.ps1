Import-Module ./QueryCommands.psm1
name_window "Update AD Users"

# Select which version of the db to compare against
Write-Host "Available Databases are:"
dir $dbdir
$comp_dbname = Read-Host "Compare against which database?"
$comp_dbname = $comp_dbname.Trim().split('.')[0]  

"dbname is " + $comp_dbname

set_up_db $comp_dbname ($dbdir + $comp_dbname + ".sqlite")

$new_list = get_svc_objects
$old_list = ls "$comp_dbname`:/$table_name"

$new_samaccountnames = $new_list | foreach {$_.samaccountname}
$old_samaccountnames = $old_list | foreach {$_.samaccountname}

# Check for accounts that were removed
  
"Accounts which were removed:-------------------------"
foreach ($saccountname in $old_samaccountnames) {
  if ($new_samaccountnames -contains $saccountname) { }
  
  else { #"*** " + $saccountname + " was removed! ***"
    #ls ADAuditsDB:/SVCTable -filter "SamAccountName like '$saccountname'" | select id,samaccountname,Auditdatestamp,accountremoved # Instrumentation
    #"Updating AccountRemoved" # Instrumentation
    #if ((ls ADAuditsDB:/SVCTable -filter "SamAccountName like '$saccountname'").accountremoved -eq "") {
    if ((query_db $comp_dbname $table_name "Samaccountname" $saccountname).accountremoved -eq "") {
      Set-item $comp_dbname`:/$table_name -filter "SamAccountName like '$saccountname'" -value @{ accountremoved=Get-Date }
      }
    else { }
      #Verify accountremoved was updated
      query_db $comp_dbname $table_name "Samaccountname" $saccountname | select id,samaccountname,Auditdatestamp,accountremoved # Instrumentation
    }
  }

#check for accounts that were added
"Accounts which were added:-----------------------"
foreach ($saccountname in $new_samaccountnames) {
  if ($old_samaccountnames -contains $saccountname) { }
  else { #"*** " + $saccountname + " was added! ***"
    
    # Add newly found user to DB
    $audit_date = get-date
    $dood = search_ad "samaccountname" $saccountname
    
    
    <#get-aduser -filter { samaccountname -eq $saccountname } -properties mail,employeeType,enabled | 
      sort -unique | select-object name,samaccountname,mail,employeetype,enabled
    #>
    persist_objects $comp_dbname $table_name $dood $audit_date
        }
  }

retain_window


<#
$i = 0
if ($new_list.length -le $old_list.length) { $length = $old_list.length; "The old list is equal or longer" }
else { $length = $new_list.length; "The new list is longer" }

while ($i -lt $length) {

"New entry " + $i + ":-------------------------"
$new_list[$i]
""
"Old entry " + $i + ":-------------------------"
$old_list[$i]
"><><><><><<><><><><><><><><><><<>><"


$i++
}
#>