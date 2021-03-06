#Import-Module ./QueryCommands.psm1
name_window "Detect Change in AD"

function not_in_ad ($base, $live) { $base | where { $live -notcontains $_ } }
function new_in_ad ($base, $live) { $live | where { $base -notcontains $_ } }

check_dbdir

# Get base file from user
Write-Host "`nPlace database in $dbdir to make it available for comparison.`nAvailable Databases are:"
dir $dbdir
$base_dbname = Read-Host "`nCompare against which database?"
$base_dbname = $base_dbname.Trim().split('.')[0]  

$discard = set_up_db $base_dbname ($dbdir + $base_dbname + ".sqlite")

# Get comparison file or live AD from user
Write-Host "`nPlace database in $dbdir to make it available for comparison.`nAvailable Databases are:"
dir $dbdir
$comp_dbname = Read-Host "`nCompare against which database? Enter `"live`" to compare against live AD"
$comp_dbname = $comp_dbname.Trim().split('.')[0]  

if (Test-Path ($dbdir + $comp_dbname + ".sqlite")) {
  "Turning back the hands of time. This may take a minute."
  
  $discard = set_up_db $comp_dbname ($dbdir + $comp_dbname + ".sqlite")
  #Invoke-Expression "ls $base_dbname`:/"
  #Invoke-Expression "ls $comp_dbname`:/"
  
  $base_svc_objects = ls "$($base_dbname):/SvcTable" | ForEach-Object { $_.samaccountname }
  $base_bangdot_objects = ls "$($base_dbname):/BangTable" | ForEach-Object { $_.samaccountname }
  $comp_svc_objects = ls "$($comp_dbname):/SvcTable" | ForEach-Object { $_.samaccountname }
  $comp_bangdot_objects = ls "$($comp_dbname):/BangTable" | ForEach-Object { $_.samaccountname }
  
  "Comp service objects -------------------------------"
  $comp_svc_objects.count
  
  "Comp Bang Dot objects ------------------------------"
  $comp_bangdot_objects.count
  
  "Base svc objects -----------------------------------"
  $base_svc_objects.count
  
  "Base bang dot objects ------------------------------"
  $base_bangdot_objects.count
  
  "`nService accounts removed between base and compare:-------------------"
  $a = not_in_ad $base_svc_objects $comp_svc_objects
  if ($a.length -gt 0) { $a }
  else { "No change" }
  
  "`nService accounts added between base and compare:------------------"
  $a = new_in_ad $base_svc_objects $comp_svc_objects 
  if ($a.length -gt 0) { $a }
  else { "No change" }
  
  "`nBang and dot accounts removed between base and compare:--------------"
  $a = not_in_ad $base_bangdot_objects $comp_bangdot_objects
  if ($a.length -gt 0) { $a }
  else { "No change" }
  
  "`nBang and dot accounts added between base and compare:-------------"
  $a = new_in_ad $base_bangdot_objects $comp_bangdot_objects 
  if ($a.length -gt 0) { $a }
  else { "No change" }
  
  "`nIf this looks odd please make sure $base_dbname is older than $comp_dbname."
  }
  
elseif ($comp_dbname -eq "live") {
  "`nDoing live things. This takes a few minutes."
  $live_svc_objects = get_svc_objects | ForEach-Object { $_.samaccountname }
  $live_bangdot_objects = get_bangdot_objects | ForEach-Object { $_.samaccountname }
  $base_svc_objects = ls "$($base_dbname):/SvcTable" | ForEach-Object { $_.samaccountname }
  $base_bangdot_objects = ls "$($base_dbname):/BangTable" | ForEach-Object { $_.samaccountname }
  
  "Live service objects -------------------------------"
  $live_svc_objects.count
  
  "live Bang Dot objects ------------------------------"
  $live_bangdot_objects.count
  
  "Base svc objects -----------------------------------"
  $base_svc_objects.count
  
  "Base bang dot objects ------------------------------"
  $base_bangdot_objects.count
  
  "`nService accounts no longer in AD:-------------------"
  #$base_svc_objects | where { $live_svc_objects -notcontains $_ }
  $a = not_in_ad $base_svc_objects $live_svc_objects
  if ($a.length -gt 0) { $a }
  else { "No change" }
  
  "`nService accounts added since base:------------------"
  #$live_svc_objects | where { $base_svc_objects -notcontains $_ } 
  $a = new_in_ad $base_svc_objects $live_svc_objects 
  if ($a.length -gt 0) { $a }
  else { "No change" }
  
  "`nBang and dot accounts no longer in AD:--------------"
  #$base_bangdot_objects | where { $live_bangdot_objects -notcontains $_ }
  $a = not_in_ad $base_bangdot_objects $live_bangdot_objects
  if ($a.length -gt 0) { $a }
  else { "No change" }
  
  "`nBang and dot accounts added since base:-------------"
  #$live_bangdot_objects | where { $base_bangdot_objects -notcontains $_ }
  $a = new_in_ad $base_bangdot_objects $live_bangdot_objects 
  if ($a.length -gt 0) { $a }
  else { "No change" }
  }
  
else {
  "`nThat probably doesn't make sense. I'll wait over here while you figure out why."
  }


retain_window
