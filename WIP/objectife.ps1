﻿function objectify ($properties_hash) {
  
  $new_object = New-Object System.Object
  $properties_hash | foreach {
    $new_object | Add-Member -type NoteProperty -name $_.keys -value $_.values
    }
  $new_object | get-member -type property
  
  }
  
$properties_hash = @{
  "ADName" = "r-y"
  "samaccountname" = "r-y"
  "employeetype" = "user"
  }
  
  $a = objectify $properties_hash
  $a
  
