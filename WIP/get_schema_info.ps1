﻿# Display the number of properties associated with user accounts. If this changes the schema was modified.

(get-aduser -filter { samaccountname -like "r-y" } -properties * | get-member -type property | foreach {$_.name}).count

# Get the list of property names that are not certificates
$goodProps = get-aduser -filter { samaccountname -like "rlutsey" } -properties * | 
  get-member -type property | where { $_.name -notmatch "cert" } | foreach {$_.name}

# Example of using good properties.
#get-aduser -filter { samaccountname -like "rlutsey" } -properties $goodProps
