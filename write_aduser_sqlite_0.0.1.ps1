Import-Module ./QueryCommands.psm1
name_window "Write AD Users to SQL"
"dbname is " + $dbname

function show_menu {
  #Write-host "---------------------------------`n"
  Write-host "Run in Demo Mode?              [1]"
  Write-Host "Run in Testing Mode?           [2]"
  #Write-Host "Run in !Demo Mode?               [3]"
  #Write-Host "Run in !Testing Mode?            [4]"
  Write-host "----------------------------------`n"
}
  
function get_input {
  show_menu
  $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
  $x.character
  }

set_up_db $dbname $dbpath

while (1 -eq 1) {
  try {
    switch (get_input) {
      "1" { $table_name = "SVCTable"
            make_demo_table $dbname $table_name
            $audit_date = Get-Date
            foreach ($dood in get_svc_objects) { 
              persist_demo_objects $dbname $table_name $dood $audit_date
            }
           }
      "2" { 
    #    ("SvcTable", "BangTable", "GroupTable") | ForEach-Object {
        ("SVCTable", "BangTable") | ForEach-Object {
          $table_name = $_
          "table_name is $table_name in 2 loop"
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
      #"3" {  "Not needed perhaps"  }
      #"4" { "Not needed perhaps" }
      default { "Sorry. That wasn't one of the choices." }
      }
    }
  Catch {
    "Something has gone wrong. Review the ouput of errors. The task was not completed."
    "The error output is:`n"
    $error
    }
  "Ctrl-c to close window"
  retain_window
}