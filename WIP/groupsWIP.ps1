﻿(get-adgroup -filter { samaccountname -like "c-m" } -properties *).members | foreach-object { (get-aduser -filter {DistinguishedName -like $_ }).samaccountname }
