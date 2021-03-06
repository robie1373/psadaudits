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

function add_password_age {
  Foreach ($inobj in $input) {
    if ($inobj.passwordlastset -ne $null) {
         $password_age = ( (get-date) - $inobj.passwordlastset ).days
         $cust_svc_obj = New-Object System.object
         $cust_svc_obj | Add-Member -type NoteProperty -name PasswordAge -value $password_age
         $cust_svc_obj | Add-Member -type NoteProperty -name samaccountname -value $inobj.samaccountname
         $cust_svc_obj | Add-Member -type NoteProperty -name passwordlastset -value $inobj.passwordlastset
         $cust_svc_obj | Add-Member -type NoteProperty -name Mail -value $inobj.mail
         $cust_svc_obj | Add-Member -type NoteProperty -name Enabled -value $inobj.enabled
       }
    $cust_svc_obj
    }
  }
  
function Copy-Property ($From, $To, $PropertyName ="*")
#from http://blogs.msdn.com/b/powershell/archive/2006/12/29/use-copy-property-to-make-it-easier-to-write-read-and-review-scripts.aspx
{
   foreach ($p in Get-Member -In $From -MemberType Property -Name $propertyName)
   {  trap {
         Add-Member -In $To -MemberType NoteProperty -Name $p.Name -Value $From.$($p.Name) -Force
         continue
      }
      $To.$($P.Name) = $From.$($P.Name)
   }
}


Export-ModuleMember -Function * -Variable *