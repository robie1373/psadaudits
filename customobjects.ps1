﻿Import-Module ./modules/Helper_module.psm1
import-module activedirectory


function Copy-Property ($From, $To, $PropertyName ="*")
{
   foreach ($p in Get-Member -In $From -MemberType Property -Name $propertyName)
   {  trap {
         Add-Member -In $To -MemberType NoteProperty -Name $p.Name -Value $From.$($p.Name) -Force
         continue
      }
      $To.$($P.Name) = $From.$($P.Name)
   }
}



$age = 365

$robie = get-aduser -filter { samaccountname -like "r-y" }
$eibor = New-Object System.object
copy-property $robie $eibor
$eibor | Add-Member NoteProperty -name foo -value "bar"

"`$eibor name is " + $eibor.samaccountname
"`$eibor foo is " + $eibor.foo

retain_window
