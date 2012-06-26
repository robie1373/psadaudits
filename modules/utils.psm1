function check_dbdir {
  if (Test-Path $dbdir) { }
  else { 
    "`n***WARNING***`n$dbdir does not exist. You should create it." 
    "This window will close in 60 seconds"
    sleep 60
    break
    }
  }
  
function check_for_errors {
"error.lenght is $($error.count)"
  if ($error.count -gt 0) {
    "There were errors during execution. `n$($errors)"
    }
  }
  
function name_window ( $window_name ) {
  $a = (Get-Host).UI.RawUI
  $a.WindowTitle = "$window_name"  
  }

function retain_window {
  Write-Host "`n`n`nCtrl-c to close window."
  $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")  
  }

Export-ModuleMember -Function * -Variable *