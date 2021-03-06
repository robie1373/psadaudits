name_window "Write AD Users to SQL"
clear-host
"dbname is $dbname`n"

function show_menu {
  #Write-host "---------------------------------`n"
  Write-host "Run in Demo Mode               [1]"
  Write-Host "Run in Production Mode         [2]"
  Write-Host "Make Group DB                  [3] Do not use lightly. Or at all."
  #Write-Host "Run in !Testing Mode?            [4]"
  Write-host "----------------------------------`n"
}
  
function get_input {
  show_menu
  $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
  $x.character
  }
  

check_dbdir

while ($true) {
  try {
    switch (get_input) {
      "1" { 
           $discard = set_up_db $dbname $dbpath
           $table_name = "SVCTable"
           make_demo_table $dbname $table_name
           $audit_date = Get-Date
           foreach ($dood in get_svc_objects) { 
             persist_demo_objects $dbname $table_name $dood $audit_date
             }
           }
      "2" {  
          $discard = set_up_db $dbname $dbpath
          "It has begun!"
          #("SvcTable", "BangTable", "GroupTable") | ForEach-Object {
          ("SVCTable", "BangTable") | ForEach-Object {
            $table_name = $_
            #"table_name is $table_name in 2 loop"
            # the next little line creates a little bubble in which $erroractionpreference is contained. It is a "Call block" apparently.
            & {
              $start_time = Get-Date
              $ErrorActionPreference="Inquire"
              write_to_sql $dbname $table_name
              $ErrorActionPreference="Continue"
              "Completed in $(($(get-date) - $start_time).TotalSeconds) seconds"
              }
            sleep 2
            }
          }
      "3" {  
           $dbname = "GrpAuditDB_" + (get-date -format MMMddyyyy-HHmmss) #override dbname so group dbs can be told apart
           $discard = set_up_db $dbname $dbpath
           "It's on like Michele Qwan. What? She sacrificed."
           ("GroupTable") | ForEach-Object {
           $table_name = $_
           # the next little line creates a little bubble in which $erroractionpreference is contained. It is a "Call block" apparently.
           & {
             $start_time = Get-Date
             $ErrorActionPreference="Inquire"
             write_to_sql $dbname $table_name
             $ErrorActionPreference="Continue"
             "Completed in $(($(get-date) - $start_time).TotalSeconds) seconds"
             }
          }
        }
      #"4" { "Not needed perhaps" }
      default { "Sorry. That wasn't one of the choices." }
      }
    }
  Catch {
    Write-warning "Something has gone wrong. Review the ouput of errors. The task was not completed."
    "The error output is:`n"
    $error
    }
  retain_window
}