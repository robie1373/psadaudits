﻿Import-Module activedirectory
import-module sqlite

$object = get-aduser -filter {samaccountname -like "r-y"} -properties *

$props = $object | Get-Member -type property | ForEach-Object {$_.name}
  foreach ($prop in $props) { 
    if ($object.$prop -eq $null) {
     
      } 
    else {
      "save $object.$prop to db"
      }
    }
