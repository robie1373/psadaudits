Import-Module ./QueryCommands.psm1
name_window "Detect Change in AD"

<#
function show_menu {
  #Write-host "---------------------------------`n"
  Write-host "Compare against file              [1]"
  Write-Host "Compare against live AD           [2]"
  #Write-Host "Run in !Demo Mode?               [3]"
  #Write-Host "Run in !Testing Mode?            [4]"
  Write-host "----------------------------------`n"
}
  
function get_input {
  show_menu
  $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
  $x.character
  }
#>

# Get base file from user
Write-Host "`nPlace database in $dbdir to make it available for comparison.`nAvailable Databases are:"
dir $dbdir
$base_dbname = Read-Host "`nCompare against which database?"
$base_dbname = $base_dbname.Trim().split('.')[0]  

set_up_db $base_dbname ($dbdir + $base_dbname + ".sqlite")

# Get comparison file or live AD from user
Write-Host "`nPlace database in $dbdir to make it available for comparison.`nAvailable Databases are:"
dir $dbdir
$comp_dbname = Read-Host "`nCompare against which database? Enter `"live`" to compare against live AD."
$comp_dbname = $comp_dbname.Trim().split('.')[0]  

if (Test-Path ($dbdir + $comp_dbname + ".sqlite")) {
  set_up_db $comp_dbname ($dbdir + $comp_dbname + ".sqlite")
  Invoke-Expression "ls $base_dbname`:/"
  Invoke-Expression "ls $comp_dbname`:/"
  }
elseif ($comp_dbname -eq "live") {
  "`nDo live things"
  $live_svc_objects = get_svc_objects | ForEach-Object { $_.samaccountname }
  $live_bangdot_objects = get_bangdot_objects | ForEach-Object { $_.samaccountname }
  $base_svc_objects = ls "$($base_dbname):/SvcTable" | ForEach-Object { $_.samaccountname }
  $base_bangdot_objects = ls "$($base_dbname):/BangTable" | ForEach-Object { $_.samaccountname }
  "Live service objects -------------------------------"
  $live_svc_objects
  "live Bang Dot objects --------------------------------"
  $live_bangdot_objects
  "Base svc objects ---------------------------------------"
  $base_svc_objects
  "Base bang dot objects -------------------------------"
  $base_bangdot_objects
  }
else {
  "`nThat probably doesn't make sense. I'll wait over here while you figure out why."
  }


retain_window
