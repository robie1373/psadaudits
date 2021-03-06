Import-Module ./modules/Helper_module.psm1
name_window "PS AD Audits"

function check_exec_pol {
  if ("AllSigned", "Restricted" -contains $(Get-ExecutionPolicy)) {
    "Your ExecutionPolicy is too restrictive to run unsigned scripts."
    "Currently it is set to $(get-excutionPolicy)"
    "To set your ExecutionPolicy open a powershell terminal as Administrator and run:"
    "Set-ExecutionPolicy RemoteSigned"
    }
  }
  
function check_sqlite_module {
  if (test-path ([Environment]::GetFolderPath("MyDocuments") + "\WindowsPowerShell\Modules\SQLite")) {}
  else {
    "You need the SQLite provider for powershell. Please download from"
    "http://psqlite.codeplex.com/ and install into WindowsPowerShell\Modules"
    "in your Documents folder."
    }
  }

function show_menu {
  Write-Host "Welcome to PS AD Audits!`n"
  #Write-host "---------------------------------`n"
  Write-host "Take snapshot of AD              [1]"
  Write-Host "Detect changes                   [2]"
  Write-Host "Search for problems              [3]"
  Write-Host "Mark groups privileged           [4]"
  Write-host "----------------------------------`n"
  Write-Host "What would you like to do? "
}
  
function get_input {
  show_menu
  $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
  $x.character
  }

check_exec_pol
check_sqlite_module
  
switch (get_input) {
  "1" {import-module ./modules/write_aduser_sqlite.ps1}
  "2" {import-module ./modules/detect_change.ps1}
  "3" {import-module ./modules/search_aduser_sqlite.ps1}
  "4" {import-module ./modules/mark_groups.ps1}
  }
  
retain_window