Import-Module activedirectory

function get_svc_objects {
  #get-aduser -filter { (name -like "svc*") -or (employeetype -like "service") } -properties mail,employeeType,enabled | 
  #  sort -unique | select-object name,samaccountname,mail,employeetype,enabled
  get-aduser -filter { (name -like "svc*") -or (employeetype -like "service") } -properties * | sort -unique
  }

function get_bangdot_objects {
  get-aduser -filter { (employeetype -like "admin") -or (samaccountname -like "!*") -or (samaccountname -like ".*") } -properties * | 
  sort -unique 
  }
  
function get_groups {
  get-adgroup -filter * -properties ManagedBy
  }
  
function search_ad ( $property, $value) { 
  get-aduser -filter { $property -eq $value } -properties mail,employeeType,enabled | 
      sort -unique | select-object name,samaccountname,mail,employeetype,enabled
  }



Export-ModuleMember -Function * -Variable *